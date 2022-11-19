import 'package:minichess/utils/Enums.dart';
import 'Tile.dart';

class GameState {
  GameState(this.board, this.myGraveyard, this.enemyGraveyard,
      this.playersTurn, this.gamemode);

  final List<List<Tile>> board;
  final List<Tile> myGraveyard;
  final List<Tile> enemyGraveyard;
  final player playersTurn;
  final gameMode gamemode;

  List<String> getStateKey() {
    //0 - pawn in my graveyard
    //1 - rock in my graveyard
    //2 - bishop in my graveyard
    //3 - knight in my graveyard
    //4 - 15 board: p:pawn r:rock b:bishop k:knight e:empty // m:my e:enemy
    //16 - pawn in enemy graveyard
    //17 - rock in enemy graveyard
    //18 - bishop in enemy graveyard
    //19 - knight in enemy graveyard

    List<String> stateKey = [];

    stateKey.add(myGraveyard.any((t) => t.char == chrt.pawn) ? '1' : '0');
    stateKey.add(myGraveyard.any((t) => t.char == chrt.rock) ? '1' : '0');
    stateKey.add(myGraveyard.any((t) => t.char == chrt.bishop) ? '1' : '0');
    stateKey.add(myGraveyard.any((t) => t.char == chrt.knight) ? '1' : '0');
    if (playersTurn == player.black) {
      for (var row in board) {
        for (var v in row) {
          stateKey.add('${v.char.name[0]}${v.char.name[1]}'
              '${v.owner == player.none ? 'n' : v.owner == playersTurn
              ? 'm'
              : 'e'}');
        }
      }
    }
    if (playersTurn == player.white) {
      for (var row in board.reversed) {
        for (var v in row.reversed) {
          stateKey.add('${v.char.name[0]}${v.char.name[1]}'
              '${v.owner == player.none ? 'n' : v.owner == playersTurn
              ? 'm'
              : 'e'}');
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

  getCharAscii(String s) {
    if (s == 'emn') {
      return '□';
    } else if (s == 'rom') {
      return '\x1B[32m○\x1B[0m';
    }
    else if (s == 'kim') {
      return '\x1B[32m☼\x1B[0m';
    }
    else if (s == 'bim') {
      return '\x1B[32m◊\x1B[0m';
    }
    else if (s == 'pam') {
      return '\x1B[32m☺\x1B[0m';
    }
    else if (s == 'pae') {
      return '\x1B[36m☺\x1B[0m';
    }
    else if (s == 'bie') {
      return '\x1B[36m◊\x1B[0m';
    }
    else if (s == 'kie') {
      return '\x1B[36m☼\x1B[0m';
    }
    else if (s == 'roe') {
      return '\x1B[36m○\x1B[0m';
    }
    return '';
  }

  void printState() {
    print('matrix:');
    List<String> arr = getStateKey();
    String sTable = '';
    sTable += arr[0] == '0' ? '□' : 'p';
    sTable += arr[1] == '0' ? '□' : 'e';
    sTable += arr[2] == '0' ? '□' : 'b';
    sTable += arr[3] == '0' ? '□' : 'k';
    sTable += '\n';
    sTable += getCharAscii(arr[4]);
    sTable += getCharAscii(arr[5]);
    sTable += getCharAscii(arr[6]);
    sTable += '\n';
    sTable += getCharAscii(arr[7]);
    sTable += getCharAscii(arr[8]);
    sTable += getCharAscii(arr[9]);
    sTable += '\n';
    sTable += getCharAscii(arr[10]);
    sTable += getCharAscii(arr[11]);
    sTable += getCharAscii(arr[12]);
    sTable += '\n';
    sTable += getCharAscii(arr[13]);
    sTable += getCharAscii(arr[14]);
    sTable += getCharAscii(arr[15]);
    sTable += '\n';
    sTable += arr[16] == '0' ? '□' : 'p';
    sTable += arr[17] == '0' ? '□' : 'e';
    sTable += arr[18] == '0' ? '□' : 'b';
    sTable += arr[19] == '0' ? '□' : 'k';
    print(sTable);
  }
}
