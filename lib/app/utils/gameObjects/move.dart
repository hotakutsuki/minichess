import 'package:minichess/app/utils/gameObjects/tile.dart';

import '../utils.dart';

class Move {
  Move(this.initialTile, this.finalTile);

  late Tile initialTile;
  late Tile finalTile;

  Move.fromString(String s){
    initialTile = getInitialTile(s.substring(0,3));
    finalTile = getFinalTile(s.substring(4));
  }

  Tile getInitialTile(String s){
    return Tile(getCharFromString(), owner, i, j);
  }

  char getCharFromString(s){
    char.
  }

  Tile getFinalTile(String s){
    return Tile(char, owner, i, j);
  }


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