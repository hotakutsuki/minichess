
import 'package:minichess/app/data/enums.dart';
import 'package:minichess/app/utils/gameObjects/tile.dart';

import '../utils.dart';
import 'move.dart';

class GameState {
  GameState(this.board, this.myGraveyard, this.enemyGraveyard);

  GameState.named({board, myGraveyard, enemyGraveyard})
      : this(board, myGraveyard, enemyGraveyard);

  List<List<Tile>> board;
  List<Tile> myGraveyard;
  List<Tile> enemyGraveyard;

  GameState changeGameState(Move move) {
    sendPieceToGrave(move);
    rewritePosition(move);
    return this;
  }

  transformPawn(Move move) {
    if (move.finalTile.char == chrt.pawn && move.finalTile.j == 3) {
      board[move.finalTile.j!][move.finalTile.i!].char = chrt.knight;
    }
  }

  sendPieceToGrave(Move move) {
    if (move.finalTile.char != chrt.empty) {
      myGraveyard.add(Tile(
          move.finalTile.char, toggleOwner(move.finalTile.owner), null, null));
    }
  }

  rewritePosition(Move move) {
    board[move.finalTile.j!][move.finalTile.i!].char = move.initialTile.char;
    board[move.finalTile.j!][move.finalTile.i!].owner = move.initialTile.owner;
    transformPawn(move);
    if (isFromGraveyard(move.initialTile)) {
      myGraveyard.removeWhere((t) => t.isSelected);
      // myGraveyard = myGraveyard.where((p) => !p.isSelected).toList();
    } else {
      board[move.initialTile.j!][move.initialTile.i!].char = chrt.empty;
      board[move.initialTile.j!][move.initialTile.i!].owner = possession.none;
    }
  }

  static GameState createNew() {
    return GameState.named(
      board: createNewBoard(),
      enemyGraveyard: List<Tile>.from([]),
      myGraveyard: List<Tile>.from([]),
    );
  }

  static List<List<Tile>> cloneBoard(board){
    List<List<Tile>> newBoard = [];
    for (var r in board){
      List<Tile> row = [];
      for(var t in r) {
        row.add(Tile(t.char, t.owner, t.i, t.j));
      }
      newBoard.add(row);
    }
    return newBoard;
  }

  static GameState clone(GameState gs) {
    return GameState.named(
      board: cloneBoard(gs.board),
      myGraveyard: [...gs.myGraveyard],
      enemyGraveyard: [...gs.enemyGraveyard],
    );
  }

  toggleOwner(possession p) {
    if (p == possession.none) {
      return p;
    }
    if (p == possession.enemy) {
      return possession.mine;
    }
    if (p == possession.mine) {
      return possession.enemy;
    }
  }

  List<List<Tile>> getReversedBoard() {
    List<List<Tile>> reversedBoard = [];
    int i = 0;
    for (var row in board.reversed) {
      List<Tile> revRow = [];
      int j = 0;
      for (var v in row.reversed) {
        revRow.add(Tile(v.char, toggleOwner(v.owner), j, i));
        j++;
      }
      reversedBoard.add(revRow);
      i++;
    }
    return reversedBoard;
  }

  rotate() {
    board = getReversedBoard();
    var aux = myGraveyard.map((e) {
      e.owner = possession.enemy;
      return e;
    }).toList();
    myGraveyard = enemyGraveyard.map((e) {
      e.owner = possession.mine;
      return e;
    }).toList();
    enemyGraveyard = aux;
  }

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
    for (var row in board) {
      for (var v in row) {
        stateKey.add('${v.char.name[0]}${v.char.name[1]}${v.owner.name[0]}');
      }
    }
    stateKey.add(enemyGraveyard.any((t) => t.char == chrt.pawn) ? '1' : '0');
    stateKey.add(enemyGraveyard.any((t) => t.char == chrt.rock) ? '1' : '0');
    stateKey.add(enemyGraveyard.any((t) => t.char == chrt.bishop) ? '1' : '0');
    stateKey.add(enemyGraveyard.any((t) => t.char == chrt.knight) ? '1' : '0');

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
      return '▪';
    } else if (s == 'rom') {
      return '\x1B[32m🛢️\x1B[0m';
    } else if (s == 'kim') {
      return '\x1B[32m👑\x1B[0m';
    } else if (s == 'bim') {
      return '\x1B[32m⚜\x1B[0m';
    } else if (s == 'pam') {
      return '\x1B[32m♟\x1B[0m';
    } else if (s == 'pae') {
      return '\x1B[36m♟\x1B[0m';
    } else if (s == 'bie') {
      return '\x1B[36m⚜\x1B[0m';
    } else if (s == 'kie') {
      return '\x1B[36m👑\x1B[0m';
    } else if (s == 'roe') {
      return '\x1B[36m🛢️\x1B[0m';
    }
    return '';
  }

  void printState() {
    print('\nmatrix:');
    List<String> arr = getStateKey();
    String sTable = '';
    sTable += arr[0] == '0' ? '▪' : 'p';
    sTable += arr[1] == '0' ? '▪' : 'e';
    sTable += arr[2] == '0' ? '▪' : 'b';
    sTable += arr[3] == '0' ? '▪' : 'k';
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
    sTable += arr[16] == '0' ? '▪' : 'p';
    sTable += arr[17] == '0' ? '▪' : 'e';
    sTable += arr[18] == '0' ? '▪' : 'b';
    sTable += arr[19] == '0' ? '▪' : 'k';
    print(sTable);
  }
}