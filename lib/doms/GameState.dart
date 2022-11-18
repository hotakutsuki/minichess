import '../utils/Enums.dart';
import 'Tile.dart';

class GameState {
  GameState(
      this.board, this.myGraveyard, this.enemyGraveyard, this.playersTurn);

  final List<List<Tile>> board;
  final List<Tile> myGraveyard;
  final List<Tile> enemyGraveyard;
  final player playersTurn;

  List<String> getStateKey() {
    //0 - pawn in my graveyard
    //1 - rock in my graveyard
    //2 - bishop in my graveyard
    //3 - knight in my graveyard
    //4 - 15 board: p:pawn r:rock b:bishop k:knight e:empty // m:my e:enemy
    //16 - pawn in enemy graveyard
    //17 - pawn in enemy graveyard
    //18 - pawn in enemy graveyard
    //19 - pawn in enemy graveyard

    List<String> stateKey = [];

    stateKey.add(myGraveyard.any((t) => t.char == chrt.pawn) ? '1' : '0');
    stateKey.add(myGraveyard.any((t) => t.char == chrt.rock) ? '1' : '0');
    stateKey.add(myGraveyard.any((t) => t.char == chrt.bishop) ? '1' : '0');
    stateKey.add(myGraveyard.any((t) => t.char == chrt.knight) ? '1' : '0');
    if (playersTurn == player.black) {
      for (var row in board) {
        for (var v in row) {
          stateKey.add('${v.char.name[0]}${v.char.name[1]}'
              '${v.owner == player.none ? 'n' : v.owner == playersTurn ? 'm' : 'e'}');
        }
      }
    }
    if (playersTurn == player.white) {
      for (var row in board.reversed) {
        for (var v in row.reversed) {
          stateKey.add('${v.char.name[0]}${v.char.name[1]}'
              '${v.owner == player.none ? 'n' : v.owner == playersTurn ? 'm' : 'e'}');
        }
      }
    }
    stateKey.add(enemyGraveyard.any((t) => t.char == chrt.pawn) ? '1' : '0');
    stateKey.add(enemyGraveyard.any((t) => t.char == chrt.rock) ? '1' : '0');
    stateKey
        .add(enemyGraveyard.any((t) => t.char == chrt.bishop) ? '1' : '0');
    stateKey
        .add(enemyGraveyard.any((t) => t.char == chrt.knight) ? '1' : '0');

    return stateKey;
  }

  @override
  String toString() {
    List<String> arr = getStateKey();
    String s = '';
    for (var e in arr) {
      s += '$e|';
    }
    return s;
  }
}