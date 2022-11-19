import '../utils/Enums.dart';
import '../utils/utils.dart';
import 'Tile.dart';

class Move {
  Move(this.initialTile, this.finalTile, this.playersTurn);

  Tile initialTile;
  Tile finalTile;
  player playersTurn;

  @override
  String toString() {
    return '${initialTile.char.name} ${initialTile.owner.name} ${initialTile.i}${initialTile.j}'
        '->${finalTile.char.name} ${finalTile.owner.name} ${finalTile.i}${finalTile.j}';
  }

  static getOppositeI(int n) {
    return 3 - n;
  }

  static getOppositej(int n) {
    return 2 - n;
  }

  String getMoveCode() {
    if (isFromGraveyard(initialTile)) {
      return '${initialTile.char.name}||${finalTile!.i}|${finalTile!.j}';
    } else {
      if (playersTurn == player.white) {
        return '${getOppositeI(initialTile!.i!)}|${getOppositej(initialTile!.j!)}'
            '|${getOppositeI(finalTile!.i!)!}|${getOppositej(finalTile!.j!)}';
      }
      if (playersTurn == player.black) {
        return '${initialTile?.i}|${initialTile?.j}|${finalTile?.i}|${finalTile?.j}';
      }
    }
    return 'error';
  }
}
