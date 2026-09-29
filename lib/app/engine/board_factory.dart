import '../data/enums.dart';
import '../utils/gameObjects/tile.dart';

/// Builds the initial 3x4 minichess board.
///
/// Pure: no Flutter / GetX / IO dependencies, so it can be unit-tested and
/// reused by future game variants (campaign, modifiers).
List<List<Tile>> createNewBoard() {
  return [
    [
      Tile(chrt.bishop, possession.mine, 0, 0),
      Tile(chrt.king, possession.mine, 1, 0),
      Tile(chrt.rock, possession.mine, 2, 0)
    ],
    [
      Tile(chrt.empty, possession.none, 0, 1),
      Tile(chrt.pawn, possession.mine, 1, 1),
      Tile(chrt.empty, possession.none, 2, 1)
    ],
    [
      Tile(chrt.empty, possession.none, 0, 2),
      Tile(chrt.pawn, possession.enemy, 1, 2),
      Tile(chrt.empty, possession.none, 2, 2)
    ],
    [
      Tile(chrt.rock, possession.enemy, 0, 3),
      Tile(chrt.king, possession.enemy, 1, 3),
      Tile(chrt.bishop, possession.enemy, 2, 3)
    ],
  ];
}

/// Builds the 5×4 final-boss board ([BoardConfig.bossFinal]): a wider back rank
/// (rock, bishop, king, bishop, rock) and a full pawn row each side — more
/// pieces than the classic board. Point-symmetric, so the per-turn 180°
/// rotation stays fair.
List<List<Tile>> createBossFinalBoard() {
  const back = [chrt.rock, chrt.bishop, chrt.king, chrt.bishop, chrt.rock];
  final board = List.generate(4,
      (j) => List.generate(5, (i) => Tile(chrt.empty, possession.none, i, j)));
  for (var i = 0; i < 5; i++) {
    board[0][i] = Tile(back[i], possession.mine, i, 0);
    board[1][i] = Tile(chrt.pawn, possession.mine, i, 1);
    board[2][i] = Tile(chrt.pawn, possession.enemy, i, 2);
    board[3][i] = Tile(back[i], possession.enemy, i, 3);
  }
  return board;
}
