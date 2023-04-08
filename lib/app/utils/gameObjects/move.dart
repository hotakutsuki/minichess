import 'package:minichess/app/utils/gameObjects/tile.dart';

import '../utils.dart';
import '../../data/enums.dart';

class Move {
  Move(this.initialTile, this.finalTile);

  late Tile initialTile;
  late Tile finalTile;

  Move.fromCode(String code){
    print('getting move from: $code');
    var codeSplited = code.split('||');
    if (codeSplited.length > 1) {//is from graveyard
      var moves = codeSplited[1].split('|');
      initialTile = Tile(getCharFromString(codeSplited[0]), possession.none, null, null);
      finalTile = Tile(chrt.empty, possession.none, moves[0] as int, moves[1] as int);
    } else {
      var moves = code.split('|');
      initialTile = Tile(chrt.empty, possession.none, moves[0] as int, moves[1] as int);
      finalTile = Tile(chrt.empty, possession.none, moves[2] as int, moves[3] as int);
    }
    print('obtained move: $this');
  }

  // Tile getInitialTileString(String s){
  //   return Tile(getCharFromString(), owner, i, j);
  // }

  chrt getCharFromString(s){
    for (chrt element in chrt.values) {
      if (element.name == s){
        return element;
      }
    }
    throw Error();
  }

  // Tile getFinalTile(String s){
  //   return Tile(char, owner, i, j);
  // }


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