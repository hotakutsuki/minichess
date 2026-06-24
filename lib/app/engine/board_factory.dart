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
