import '../data/enums.dart';

/// Shape and promotion rules of a board.
///
/// Pure data (no Flutter/GetX), so variants — e.g. a boss stage that grows the
/// board — are just different [BoardConfig]s. The board rotates each turn, so
/// everything here is expressed from the mover's ("mine") perspective.
class BoardConfig {
  /// Number of columns (the `i` axis).
  final int width;

  /// Number of rows (the `j` axis).
  final int height;

  /// What a pawn becomes when it reaches the far rank.
  final chrt promotesTo;

  const BoardConfig({
    required this.width,
    required this.height,
    this.promotesTo = chrt.knight,
  });

  /// The current game: a 3×4 board, pawn promotes to a knight.
  static const BoardConfig classic = BoardConfig(width: 3, height: 4);

  /// Row a `mine` pawn promotes on (the far rank).
  int get promotionRow => height - 1;
}
