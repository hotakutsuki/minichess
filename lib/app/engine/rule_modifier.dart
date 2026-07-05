import '../data/enums.dart';
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
/// PR 1 ships only the movement hook ([transformOffsets]); later hooks (capture
/// resolution, per-turn ticks, win condition) will be added as more methods
/// here, each defaulting to a no-op so existing modifiers keep compiling.
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
