import 'package:flutter_test/flutter_test.dart';
import 'package:inti_the_inka_chess_game/app/data/enums.dart';
import 'package:inti_the_inka_chess_game/app/engine/board_factory.dart';
import 'package:inti_the_inka_chess_game/app/engine/rules.dart';
import 'package:inti_the_inka_chess_game/app/utils/gameObjects/gameState.dart';
import 'package:inti_the_inka_chess_game/app/utils/gameObjects/move.dart';
import 'package:inti_the_inka_chess_game/app/utils/gameObjects/tile.dart';

// Characterization tests for the pure rules engine.
//
// These lock the CURRENT behaviour (bugs included) so the upcoming data-driven
// movement refactor can be proven behaviour-preserving. The engine imports no
// Flutter/GetX/audio, which is exactly why this file can run as a plain unit
// test — if that ever breaks, the extraction has regressed.

GameState _stateWith(List<List<Tile>> board) => GameState.named(
    board: board, myGraveyard: <Tile>[], enemyGraveyard: <Tile>[]);

List<List<Tile>> _emptyBoard() => List.generate(
    4, (j) => List.generate(3, (i) => Tile(chrt.empty, possession.none, i, j)));

// A move of piece [c] owned by [o] from (i0,j0) onto an empty (i1,j1).
Move _move(chrt c, possession o, int i0, int j0, int i1, int j1) =>
    Move(Tile(c, o, i0, j0), Tile(chrt.empty, possession.none, i1, j1));

void main() {
  group('createNewBoard', () {
    final board = createNewBoard();
    test('is 4 rows x 3 cols', () {
      expect(board.length, 4);
      expect(board.every((r) => r.length == 3), isTrue);
    });
    test('my back rank is bishop, king, rock', () {
      expect(board[0][0].char, chrt.bishop);
      expect(board[0][0].owner, possession.mine);
      expect(board[0][1].char, chrt.king);
      expect(board[0][2].char, chrt.rock);
    });
    test('pawns face off in the middle', () {
      expect(board[1][1].char, chrt.pawn);
      expect(board[1][1].owner, possession.mine);
      expect(board[2][1].char, chrt.pawn);
      expect(board[2][1].owner, possession.enemy);
    });
    test('enemy back rank is rock, king, bishop', () {
      expect(board[3][0].char, chrt.rock);
      expect(board[3][1].char, chrt.king);
      expect(board[3][2].char, chrt.bishop);
      expect(board[3][1].owner, possession.enemy);
    });
  });

  group('isFromGraveyard', () {
    test('true when the tile has no board coordinates', () {
      expect(isFromGraveyard(Tile(chrt.pawn, possession.mine, null, null)),
          isTrue);
    });
    test('false for a placed tile', () {
      expect(isFromGraveyard(Tile(chrt.pawn, possession.mine, 1, 1)), isFalse);
    });
  });

  group('checkIfWin', () {
    test('capturing a king wins', () {
      final m = Move(Tile(chrt.rock, possession.mine, 0, 0),
          Tile(chrt.king, possession.enemy, 0, 1));
      expect(checkIfWin(m), isTrue);
    });
    test('capturing a non-king does not win', () {
      final m = Move(Tile(chrt.rock, possession.mine, 0, 0),
          Tile(chrt.pawn, possession.enemy, 0, 1));
      expect(checkIfWin(m), isFalse);
    });
  });

  final gs = _stateWith(_emptyBoard());

  group('pawn movement', () {
    test('my pawn advances one row forward (j+1, same column)', () {
      expect(isValidMovmentPerPiece(_move(chrt.pawn, possession.mine, 1, 1, 1, 2),
          gs, true), isTrue);
    });
    test('my pawn cannot jump two rows', () {
      expect(isValidMovmentPerPiece(_move(chrt.pawn, possession.mine, 1, 1, 1, 3),
          gs, true), isFalse);
    });
    test('enemy pawn advances the opposite way (j-1)', () {
      expect(isValidMovmentPerPiece(
          _move(chrt.pawn, possession.enemy, 1, 2, 1, 1), gs, true), isTrue);
    });
  });

  group('bishop movement (one diagonal step)', () {
    test('valid diagonal', () {
      expect(isValidMovmentPerPiece(
          _move(chrt.bishop, possession.mine, 0, 0, 1, 1), gs, true), isTrue);
    });
    test('invalid straight', () {
      expect(isValidMovmentPerPiece(
          _move(chrt.bishop, possession.mine, 0, 0, 0, 1), gs, true), isFalse);
    });
  });

  group('rock movement (one orthogonal step)', () {
    test('valid vertical', () {
      expect(isValidMovmentPerPiece(_move(chrt.rock, possession.mine, 1, 1, 1, 2),
          gs, true), isTrue);
    });
    test('invalid diagonal', () {
      expect(isValidMovmentPerPiece(_move(chrt.rock, possession.mine, 1, 1, 2, 2),
          gs, true), isFalse);
    });
  });

  group('king movement (one step, any direction, hard=true)', () {
    test('valid diagonal step', () {
      expect(isValidMovmentPerPiece(_move(chrt.king, possession.mine, 1, 1, 2, 2),
          gs, true), isTrue);
    });
    test('staying put is invalid', () {
      expect(isValidMovmentPerPiece(_move(chrt.king, possession.mine, 1, 1, 1, 1),
          gs, true), isFalse);
    });
    test('two steps is invalid', () {
      expect(isValidMovmentPerPiece(_move(chrt.king, possession.mine, 1, 1, 1, 3),
          gs, true), isFalse);
    });
  });

  // KNOWN bug locked on purpose: the knight branch compares `owner` (a
  // `possession`) against `player.white` (always false), so mine and enemy
  // knights share the exact same 6-move set. Revisit when we decide to fix it.
  group('knight movement (current/buggy behaviour)', () {
    final targets = <List<int>>[
      [1, 2],
      [2, 1],
      [0, 1],
      [1, 0],
      [2, 2],
      [0, 2],
    ];
    test('mine and enemy knights share the same 6 destinations', () {
      for (final o in [possession.mine, possession.enemy]) {
        for (final t in targets) {
          expect(
              isValidMovmentPerPiece(
                  _move(chrt.knight, o, 1, 1, t[0], t[1]), gs, true),
              isTrue,
              reason: 'owner=$o target=$t should be valid');
        }
      }
    });
    test('a cell outside that set is invalid', () {
      expect(isValidMovmentPerPiece(_move(chrt.knight, possession.mine, 1, 1, 0, 0),
          gs, true), isFalse);
    });
  });

  group('checkIfValidMove integration', () {
    test('cannot capture your own piece', () {
      final m = Move(Tile(chrt.rock, possession.mine, 1, 1),
          Tile(chrt.pawn, possession.mine, 1, 2));
      expect(checkIfValidMove(m, gs, true), isFalse);
    });
    test('from graveyard: valid only onto an empty tile', () {
      final fromGrave = Tile(chrt.pawn, possession.mine, null, null);
      expect(
          checkIfValidMove(
              Move(fromGrave, Tile(chrt.empty, possession.none, 0, 0)), gs, true),
          isTrue);
      expect(
          checkIfValidMove(
              Move(fromGrave, Tile(chrt.pawn, possession.enemy, 0, 0)), gs, true),
          isFalse);
    });
  });

  group('isInCheck', () {
    test('the initial position is not check', () {
      expect(isInCheck(_stateWith(createNewBoard())), isFalse);
    });
    test('an enemy rock next to my king is check', () {
      final b = _emptyBoard();
      b[1][1] = Tile(chrt.king, possession.mine, 1, 1);
      b[0][1] = Tile(chrt.rock, possession.enemy, 1, 0);
      expect(isInCheck(_stateWith(b)), isTrue);
    });
  });
}
