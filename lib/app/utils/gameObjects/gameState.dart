
import 'package:inti_the_inka_chess_game/app/utils/gameObjects/tile.dart';

import '../../data/enums.dart';

import '../../engine/board_config.dart';
import '../../engine/board_factory.dart';
import '../../engine/rule_modifier.dart';
import '../../engine/rules.dart';
import 'move.dart';

class GameState {
  GameState(this.board, this.myGraveyard, this.enemyGraveyard,
      {this.config = BoardConfig.classic,
      this.modifiers = const [],
      this.mineIsProtagonist = true});

  GameState.named(
      {board,
      myGraveyard,
      enemyGraveyard,
      BoardConfig config = BoardConfig.classic,
      List<RuleModifier> modifiers = const [],
      bool mineIsProtagonist = true})
      : this(board, myGraveyard, enemyGraveyard,
            config: config,
            modifiers: modifiers,
            mineIsProtagonist: mineIsProtagonist);

  List<List<Tile>> board;
  List<Tile> myGraveyard;
  List<Tile> enemyGraveyard;
  final BoardConfig config;

  /// Active rule changes (boss powers / jokers). Empty == vanilla rules.
  /// Modifiers are immutable, so [clone] copies the list reference.
  final List<RuleModifier> modifiers;

  /// Whether the current `mine` frame belongs to the protagonist (the human /
  /// campaign hero). The board rotates each turn, so `mine`/`enemy` flip owners;
  /// this stable flag lets a [RuleModifier] target the protagonist or antagonist
  /// durably (see [RuleModifier.appliesTo]). Flipped by [rotate].
  bool mineIsProtagonist;

  GameState changeGameState(Move move) {
    // `move.finalTile` aliases the board tile, which `rewritePosition` overwrites
    // with the mover — so decide whether this was a capture up front.
    final wasCapture = move.finalTile.char != chrt.empty;
    sendPieceToGrave(move);
    rewritePosition(move);
    if (wasCapture) applyExtraCaptures(move);
    return this;
  }

  // Runs every active modifier's per-turn effect (spawn, wither, wind...). Call
  // once when a side's turn begins, with that side as `mine`. Pure w.r.t. the
  // engine; the match loop decides when to invoke it. No-op with no modifiers.
  void applyTurnStart() {
    for (final m in modifiers) {
      if (m.appliesTo(possession.mine, this)) {
        m.onTurnStart(this);
      }
    }
  }

  transformPawn(Move move) {
    if (move.finalTile.char == chrt.pawn &&
        move.finalTile.j == config.promotionRow) {
      board[move.finalTile.j!][move.finalTile.i!].char = config.promotesTo;
    }
  }

  sendPieceToGrave(Move move) {
    if (move.finalTile.char != chrt.empty) {
      _sendToGrave(move.finalTile.char, move.finalTile.owner);
    }
  }

  // A captured piece normally becomes the captor's (redeployable from its
  // graveyard, Shogi-style). The "invertir posesión" modifier instead returns
  // it to its original owner. At this point the captor is always `mine`, so the
  // captured piece's [owner] is `enemy`.
  void _sendToGrave(chrt char, possession owner) {
    final returnToOwner = modifiers.any(
        (m) => m.appliesTo(possession.mine, this) && m.returnsCapturedToOwner());
    final buried = graveChar(char, owner);
    if (returnToOwner) {
      enemyGraveyard.add(Tile(buried, owner, null, null));
    } else {
      myGraveyard.add(Tile(buried, toggleOwner(owner), null, null));
    }
  }

  /// The character a piece is buried as when it dies. Folds the modifiers'
  /// display transforms so a piece turned into an oso ("todas se vuelven osos")
  /// also *dies* as an oso — and redeploys from the graveyard as a real one —
  /// rather than reverting to its original sprite. No-op without modifiers.
  chrt graveChar(chrt char, possession owner) {
    var c = char;
    for (final m in modifiers) {
      if (m.appliesTo(owner, this)) c = m.displayChar(c, owner);
    }
    return c;
  }

  // Side-effect captures (e.g. Oso "Embestida"), applied by [changeGameState]
  // only when the move was a capture, after the mover has been placed. Only
  // enemy-occupied, on-board tiles are affected.
  void applyExtraCaptures(Move move) {
    for (final m in modifiers) {
      if (!m.appliesTo(possession.mine, this)) continue;
      for (final c in m.extraCaptures(move, this)) {
        final i = c[0];
        final j = c[1];
        if (j < 0 || j >= board.length || i < 0 || i >= board[j].length) {
          continue;
        }
        final t = board[j][i];
        // Never let a side-effect capture remove a king — that would end the
        // game with no winner detected. Kings only fall to a direct capture.
        if (t.owner == possession.enemy &&
            t.char != chrt.empty &&
            t.char != chrt.king) {
          _sendToGrave(t.char, t.owner);
          t.char = chrt.empty;
          t.owner = possession.none;
        }
      }
    }
  }

  rewritePosition(Move move) {
    board[move.finalTile.j!][move.finalTile.i!].char = move.initialTile.char;
    board[move.finalTile.j!][move.finalTile.i!].owner = move.initialTile.owner;
    board[move.finalTile.j!][move.finalTile.i!].idleTurns = 0; // moving resets wither
    transformPawn(move);
    if (isFromGraveyard(move.initialTile)) {
      int idxRemove = myGraveyard.indexWhere((t) => t.char == move.initialTile.char);
      myGraveyard.removeAt(idxRemove);
      // myGraveyard.removeWhere((t) => t.isSelected);
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
        row.add(Tile(t.char, t.owner, t.i, t.j,
            idleTurns: t.idleTurns, felledTurns: t.felledTurns));
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
      config: gs.config,
      modifiers: gs.modifiers,
      mineIsProtagonist: gs.mineIsProtagonist,
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
        revRow.add(Tile(v.char, toggleOwner(v.owner), j, i,
            idleTurns: v.idleTurns, felledTurns: v.felledTurns));
        j++;
      }
      reversedBoard.add(revRow);
      i++;
    }
    return reversedBoard;
  }

  rotate() {
    board = getReversedBoard();
    mineIsProtagonist = !mineIsProtagonist; // `mine` now refers to the other side
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