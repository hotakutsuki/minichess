import '../data/enums.dart';
import '../utils/gameObjects/gameState.dart';
import '../utils/gameObjects/move.dart';
import '../utils/gameObjects/tile.dart';
import 'rules.dart';

/// Whom a [RuleModifier] targets. Unlike [possession] (which is frame-relative —
/// the mover is always `mine` because the board rotates every turn), these are
/// STABLE identities, resolved via [GameState.mineIsProtagonist], so a boss-only
/// power keeps hitting the boss across turns.
enum ModifierSide { both, protagonist, antagonist }

/// A rule change carried by a [GameState] and applied at defined engine hook
/// points. Boss powers (campaign) and player jokers are both [RuleModifier]s;
/// [side] marks who it affects (stably — see [ModifierSide]).
///
/// Every hook defaults to a no-op, so an **empty modifier list == vanilla
/// rules**. Modifiers must be immutable: a [GameState] is cloned constantly by
/// the AI look-ahead and only the reference to the modifier list is copied.
///
/// Hooks: [transformOffsets] (movement), [allowsMove] (move legality),
/// [returnsCapturedToOwner] + [extraCaptures] (capture resolution),
/// [onTurnStart] (per-turn effects). The engine gates each by [appliesTo].
abstract class RuleModifier {
  const RuleModifier();

  /// Stable target side. Default: both.
  ModifierSide get side => ModifierSide.both;

  /// Whether this modifier affects a piece/move owned by [owner] in [gs]'s
  /// current frame — mapping the stable [side] onto the rotating `mine`/`enemy`.
  bool appliesTo(possession owner, GameState gs) {
    switch (side) {
      case ModifierSide.both:
        return true;
      case ModifierSide.protagonist:
        return (owner == possession.mine) == gs.mineIsProtagonist;
      case ModifierSide.antagonist:
        return (owner == possession.mine) != gs.mineIsProtagonist;
    }
  }

  /// Movement hook. Transform a piece's [base] relative offsets (from
  /// [pieceOffsets]). Called by [effectiveOffsets] only when [appliesTo] the
  /// piece's owner. Must return a **new** list, never mutate [base].
  List<List<int>> transformOffsets(
          chrt piece, possession owner, List<List<int>> base) =>
      base;

  /// Display hook (rendering only). The character to SHOW for a piece — may
  /// differ from its stored [chrt] so a piece transformed to move like the oso
  /// also looks like one. Default: unchanged.
  chrt displayChar(chrt piece, possession owner) => piece;

  /// Legality hook. Return false to veto an otherwise-legal [move] (e.g. a tile
  /// the protagonist may not enter). Default: allowed.
  bool allowsMove(Move move, GameState gs) => true;

  /// Capture hook — disposition. If true, a piece captured by the current mover
  /// is **not** claimed by the captor (the vanilla Shogi-style drop); it returns
  /// to its original owner instead. The first applicable modifier wins.
  bool returnsCapturedToOwner() => false;

  /// Capture hook — side effects. Extra board tiles (`[i, j]` pairs) cleared as
  /// a consequence of a capturing [move] (e.g. the Oso's "Embestida"). Off-board
  /// or non-enemy tiles in the result are ignored by the engine. Default: none.
  List<List<int>> extraCaptures(Move move, GameState gs) => const [];

  /// Per-turn hook. Runs once at the start of the side-to-move's turn (the mover
  /// is `mine`), letting a modifier mutate the board outside a normal move —
  /// spawn reinforcements, wither idle pieces, blow a wind. Default: no-op.
  void onTurnStart(GameState gs) {}
}

/// Joker "doble paso": the affected side's pieces gain a **2-square** option in
/// each direction they can already move, on top of their normal 1-square moves.
/// The board has no path/blocking logic (every base move is one exact step), so
/// a 2-step move simply reaches a farther exact square.
class DoubleStepModifier extends RuleModifier {
  const DoubleStepModifier({this.side = ModifierSide.both});

  @override
  final ModifierSide side;

  @override
  List<List<int>> transformOffsets(
      chrt piece, possession owner, List<List<int>> base) {
    return [
      ...base,
      for (final o in base) [o[0] * 2, o[1] * 2],
    ];
  }
}

/// Boss power (Oso, life 2) "todas se vuelven osos": every one of the affected
/// side's pieces moves like [target] (default the knight/oso), regardless of
/// what it actually is. The **king is left untouched** (its move is gated
/// specially and it is the win target); empty tiles are ignored.
class TransformAllPiecesModifier extends RuleModifier {
  const TransformAllPiecesModifier(
      {this.target = chrt.knight, this.side = ModifierSide.both});

  final chrt target;

  @override
  final ModifierSide side;

  @override
  List<List<int>> transformOffsets(
      chrt piece, possession owner, List<List<int>> base) {
    if (piece == chrt.king || piece == chrt.empty) return base;
    // Resolve the target's offsets for THIS owner so direction-dependent targets
    // (like the knight) still mirror correctly.
    return pieceOffsets(target, owner);
  }

  @override
  chrt displayChar(chrt piece, possession owner) =>
      (piece == chrt.king || piece == chrt.empty) ? piece : target;
}

/// Rule "invertir posesión de captura": captured pieces are never claimed by the
/// captor — they return to their original owner (no drops from the pieces you
/// took).
class ReturnCapturedModifier extends RuleModifier {
  const ReturnCapturedModifier({this.side = ModifierSide.both});

  @override
  final ModifierSide side;

  @override
  bool returnsCapturedToOwner() => true;
}

/// Oso "Embestida" (also a candidate joker): a capturing move also clears the
/// orthogonally-adjacent enemy pieces around the square the mover lands on.
class AreaCaptureModifier extends RuleModifier {
  const AreaCaptureModifier({this.side = ModifierSide.both});

  @override
  final ModifierSide side;

  @override
  List<List<int>> extraCaptures(Move move, GameState gs) {
    final i = move.finalTile.i!;
    final j = move.finalTile.j!;
    return [
      [i + 1, j],
      [i - 1, j],
      [i, j + 1],
      [i, j - 1],
    ];
  }
}

/// Llama boss (life 2) "Rebrote": every [everyTurns] of the affected side's turns
/// a fresh [piece] sprouts on the first empty tile scanning from that side's home
/// rank (j=0) outward — i.e. on its own back line first. A full board spawns
/// nothing.
///
/// Holds a small countdown; [onTurnStart] is only ever called by the real match
/// loop (never the AI look-ahead), so this mutable state is safe.
class SpawnModifier extends RuleModifier {
  SpawnModifier(
      {this.piece = chrt.pawn,
      this.everyTurns = 2,
      this.side = ModifierSide.both});

  final chrt piece;
  final int everyTurns;

  @override
  final ModifierSide side;

  int _untilNext = 1; // first spawn on the first eligible turn, then every N

  /// Turns until the next spawn (for UI); 1 means it sprouts this turn.
  int get turnsUntilNext => _untilNext.clamp(0, everyTurns);

  @override
  void onTurnStart(GameState gs) {
    if (--_untilNext > 0) return;
    _untilNext = everyTurns;
    for (final row in gs.board) {
      for (final t in row) {
        if (t.char == chrt.empty) {
          t.char = piece;
          t.owner = possession.mine;
          return;
        }
      }
    }
  }
}

/// Cóndor boss (life 2) "Viento": every [everyTurns] of the affected side's turns
/// a gust pushes every piece one step by `[di, dj]`. A piece blown off the board
/// is removed to its own owner's graveyard. **Kings are anchored** — the wind
/// never moves or removes a king (so the sun can't be blown away). Because the
/// push is a rigid translation, distinct pieces never collide; processing the
/// frontier (pieces nearest the push edge) first keeps each destination free.
///
/// Holds a countdown for the next gust (real-loop only, safe — see [SpawnModifier]).
class WindModifier extends RuleModifier {
  WindModifier(
      {required this.di,
      required this.dj,
      this.everyTurns = 5,
      this.side = ModifierSide.both});

  final int di;
  final int dj;
  final int everyTurns;

  @override
  final ModifierSide side;

  late int _untilNext = everyTurns; // gust after `everyTurns` turns, then repeat

  /// Turns until the next gust (for UI).
  int get turnsUntilNext => _untilNext.clamp(0, everyTurns);

  @override
  void onTurnStart(GameState gs) {
    if (--_untilNext > 0) return;
    _untilNext = everyTurns;

    final height = gs.board.length;
    final width = gs.board.isEmpty ? 0 : gs.board[0].length;

    final pieces = <Tile>[
      for (final row in gs.board)
        for (final t in row)
          if (t.char != chrt.empty && t.char != chrt.king) t
    ];
    pieces.sort((a, b) =>
        (b.i! * di + b.j! * dj).compareTo(a.i! * di + a.j! * dj));

    for (final t in pieces) {
      final ni = t.i! + di;
      final nj = t.j! + dj;
      final char = t.char;
      final owner = t.owner;
      t.char = chrt.empty;
      t.owner = possession.none;
      if (nj < 0 || nj >= height || ni < 0 || ni >= width) {
        if (owner == possession.mine) {
          gs.myGraveyard.add(Tile(char, possession.mine, null, null));
        } else {
          gs.enemyGraveyard.add(Tile(char, possession.enemy, null, null));
        }
      } else {
        final dest = gs.board[nj][ni];
        dest.char = char;
        dest.owner = owner;
      }
    }
  }
}

/// Cóndor boss (life 1) "Marchitar": a piece the mover leaves unmoved for
/// [turns] of its own turns withers and dies (removed to its owner's graveyard).
/// The king never withers. Ages the mover's pieces each turn; moving a piece
/// resets its age (see [GameState.rewritePosition]).
class WitherModifier extends RuleModifier {
  const WitherModifier({this.turns = 3, this.side = ModifierSide.both});

  final int turns;

  @override
  final ModifierSide side;

  @override
  void onTurnStart(GameState gs) {
    for (final row in gs.board) {
      for (final t in row) {
        if (t.owner != possession.mine ||
            t.char == chrt.empty ||
            t.char == chrt.king) {
          continue;
        }
        t.idleTurns++;
        if (t.idleTurns >= turns) {
          gs.myGraveyard.add(Tile(t.char, possession.mine, null, null));
          t.char = chrt.empty;
          t.owner = possession.none;
          t.idleTurns = 0;
        }
      }
    }
  }
}

/// Leñador boss (life 1) "Tala el tablero": a spreading hazard. On each of the
/// affected side's turns one new square — adjacent to an already-felled one, or
/// the board centre if none are felled — is felled for [duration] turns, while
/// existing felled squares count down back to normal. The affected side (default
/// the protagonist) may not enter a felled square; felling never removes pieces.
///
/// State lives on the tiles ([Tile.felledTurns]), so it travels with the board
/// through rotation.
class FelledTilesModifier extends RuleModifier {
  const FelledTilesModifier(
      {this.side = ModifierSide.protagonist, this.duration = 2});

  final int duration;

  @override
  final ModifierSide side;

  @override
  void onTurnStart(GameState gs) {
    for (final row in gs.board) {
      for (final t in row) {
        if (t.felledTurns > 0) t.felledTurns--;
      }
    }
    final height = gs.board.length;
    final width = gs.board.isEmpty ? 0 : gs.board[0].length;
    final felled = <Tile>[
      for (final row in gs.board)
        for (final t in row)
          if (t.felledTurns > 0) t
    ];
    if (felled.isEmpty) {
      gs.board[height ~/ 2][width ~/ 2].felledTurns = duration; // seed
      return;
    }
    const dirs = [
      [1, 0],
      [-1, 0],
      [0, 1],
      [0, -1]
    ];
    for (final t in felled) {
      for (final d in dirs) {
        final ni = t.i! + d[0];
        final nj = t.j! + d[1];
        if (nj < 0 || nj >= height || ni < 0 || ni >= width) continue;
        final n = gs.board[nj][ni];
        if (n.felledTurns == 0) {
          n.felledTurns = duration; // spread to a fresh neighbour
          return;
        }
      }
    }
  }

  @override
  bool allowsMove(Move move, GameState gs) {
    if (!appliesTo(move.initialTile.owner, gs)) return true;
    final fi = move.finalTile.i;
    final fj = move.finalTile.j;
    if (fi == null || fj == null) return true;
    // Read the actual board tile (the move's finalTile may be a lightweight
    // destination without the felled state).
    return gs.board[fj][fi].felledTurns == 0;
  }
}
