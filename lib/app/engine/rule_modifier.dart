import '../data/enums.dart';
import '../utils/gameObjects/gameState.dart';
import '../utils/gameObjects/move.dart';
import '../utils/gameObjects/tile.dart';
import 'rules.dart';

/// A rule change carried by a [GameState] and applied at defined engine hook
/// points. Boss powers (campaign) and player jokers are both [RuleModifier]s;
/// [side] marks who it affects.
///
/// Every hook defaults to a no-op, so an **empty modifier list == vanilla
/// rules** — the engine behaves exactly as before unless a match opts in. This
/// is the single extension seam the campaign/joker systems build on. Modifiers
/// must be immutable: a [GameState] is cloned constantly by the AI look-ahead
/// and only the reference to the modifier list is copied.
///
/// PR 1 shipped the movement hook ([transformOffsets]); PR 2 adds the capture
/// hooks ([returnsCapturedToOwner], [extraCaptures]). Later hooks (per-turn
/// ticks, win condition) will be added the same way — each defaulting to a
/// no-op so existing modifiers keep compiling.
///
/// SIDE CAVEAT: at capture time the mover is always [possession.mine] (the board
/// rotates each turn), so for the capture hooks [side] is frame-relative ("the
/// side to move"), not a stable player/boss identity. Durable player-vs-boss
/// targeting is a known follow-up (the [GameState] must carry which frame is the
/// protagonist's).
abstract class RuleModifier {
  const RuleModifier();

  /// Which side the modifier affects. [possession.none] means both sides.
  possession get side => possession.none;

  bool appliesTo(possession owner) =>
      side == possession.none || side == owner;

  /// Movement hook. Given a piece's [base] relative offsets (from
  /// [pieceOffsets]), return the offsets it may actually use. Default: the
  /// offsets are returned unchanged. Implementations must return a **new** list
  /// and never mutate [base] (some base tables are `const`).
  List<List<int>> transformOffsets(
          chrt piece, possession owner, List<List<int>> base) =>
      base;

  /// Capture hook — disposition. If true, a piece captured by the current mover
  /// is **not** claimed by the captor (the vanilla, Shogi-style drop); it
  /// returns to its original owner instead. The first applicable modifier wins.
  bool returnsCapturedToOwner() => false;

  /// Capture hook — side effects. Extra board tiles (`[i, j]` pairs) cleared as
  /// a consequence of a capturing [move] (e.g. the Oso's "Embestida" area hit).
  /// Off-board or non-enemy tiles in the result are ignored by the engine.
  /// Default: none.
  List<List<int>> extraCaptures(Move move, GameState gs) => const [];

  /// Per-turn hook. Runs once at the start of the side-to-move's turn (the mover
  /// is [possession.mine] in the current frame), letting a modifier mutate the
  /// board outside of a normal move — spawn reinforcements, wither idle pieces,
  /// blow a wind across the board. Default: no-op.
  ///
  /// Frame-relative like the capture hooks (see the SIDE CAVEAT above).
  void onTurnStart(GameState gs) {}
}

/// Joker "doble paso": the affected side's pieces gain a **2-square** option in
/// each direction they can already move, on top of their normal 1-square moves.
///
/// The board has no path/blocking logic (every base move is a single exact
/// step), so a 2-step move simply reaches a farther exact square — consistent
/// with how the engine already models movement.
class DoubleStepModifier extends RuleModifier {
  const DoubleStepModifier({this.side = possession.none});

  @override
  final possession side;

  @override
  List<List<int>> transformOffsets(
      chrt piece, possession owner, List<List<int>> base) {
    if (!appliesTo(owner)) return base;
    return [
      ...base,
      for (final o in base) [o[0] * 2, o[1] * 2],
    ];
  }
}

/// Boss power (Oso, life 2) "todas se vuelven osos": every one of the affected
/// side's pieces moves like [target] (default the knight/oso), regardless of
/// what it actually is.
///
/// The **king is left untouched** — its move is gated specially by the engine
/// (king-safety look-ahead) and it is the win target, so transforming it would
/// change unrelated rules. Empty tiles are likewise ignored (they never move).
class TransformAllPiecesModifier extends RuleModifier {
  const TransformAllPiecesModifier(
      {this.target = chrt.knight, this.side = possession.none});

  final chrt target;

  @override
  final possession side;

  @override
  List<List<int>> transformOffsets(
      chrt piece, possession owner, List<List<int>> base) {
    if (!appliesTo(owner) || piece == chrt.king || piece == chrt.empty) {
      return base;
    }
    // Resolve the target's offsets for THIS owner so direction-dependent
    // targets (like the knight) still mirror correctly.
    return pieceOffsets(target, owner);
  }
}

/// Rule "invertir posesión de captura": captured pieces are never claimed by the
/// captor — they return to their original owner (no Shogi-style drops from your
/// own graveyard of the pieces you took).
class ReturnCapturedModifier extends RuleModifier {
  const ReturnCapturedModifier({this.side = possession.none});

  @override
  final possession side;

  @override
  bool returnsCapturedToOwner() => true;
}

/// Oso "Embestida" (also a candidate joker): a capturing move also clears the
/// orthogonally-adjacent enemy pieces around the square the mover lands on.
class AreaCaptureModifier extends RuleModifier {
  const AreaCaptureModifier({this.side = possession.none});

  @override
  final possession side;

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

/// Llama boss (life 2) "Rebrote": each turn a fresh [piece] of the mover's side
/// sprouts on the board. Placement is the first empty tile scanning from the
/// mover's home rank (j=0) outward; if the board is full, nothing spawns.
class SpawnModifier extends RuleModifier {
  const SpawnModifier({this.piece = chrt.pawn, this.side = possession.none});

  final chrt piece;

  @override
  final possession side;

  @override
  void onTurnStart(GameState gs) {
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

/// Cóndor boss (life 2) "Viento": every piece is pushed one step by `[di, dj]`.
/// A piece blown off the board is removed to its own owner's graveyard. Because
/// the push is a rigid translation, distinct pieces never collide; processing
/// the frontier (pieces nearest the push edge) first keeps each destination
/// free before the next piece arrives.
class WindModifier extends RuleModifier {
  const WindModifier(
      {required this.di, required this.dj, this.side = possession.none});

  final int di;
  final int dj;

  @override
  final possession side;

  @override
  void onTurnStart(GameState gs) {
    final height = gs.board.length;
    final width = gs.board.isEmpty ? 0 : gs.board[0].length;

    final pieces = <Tile>[
      for (final row in gs.board)
        for (final t in row)
          if (t.char != chrt.empty) t
    ];
    // Frontier first: highest projection onto the push vector moves first.
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
        // Blown off the board -> removed to its owner's graveyard.
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
