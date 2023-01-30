import 'package:minichess/app/utils/gameObjects/tile.dart';

import '../utils.dart';

class Move {
  Move(this.initialTile, this.finalTile);

  Tile initialTile;
  Tile finalTile;

  @override
  String toString() {
    return '${initialTile.char.name} ${initialTile.owner.name} ${initialTile.i}${initialTile.j}'
        '->${finalTile.char.name} ${finalTile.owner.name} ${finalTile.i}${finalTile.j}';
  }

  String getMoveCode() {
    if (isFromGraveyard(initialTile)) {
      return '${initialTile.char.name}||${finalTile!.i}|${finalTile!.j}';
    } else {
      return '${initialTile!.i}|${initialTile!.j}'
          '|${finalTile!.i}|${finalTile!.j}';
    }
  }
}