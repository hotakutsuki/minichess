import '../data/enums.dart';
import '../utils/gameObjects/gameState.dart';
import '../utils/gameObjects/move.dart';
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
