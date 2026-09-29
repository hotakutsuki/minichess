import 'package:flutter_test/flutter_test.dart';
import 'package:inti_the_inka_chess_game/app/data/enums.dart';
import 'package:inti_the_inka_chess_game/app/engine/board_config.dart';
import 'package:inti_the_inka_chess_game/app/engine/board_factory.dart';
import 'package:inti_the_inka_chess_game/app/utils/gameObjects/gameState.dart';
import 'package:inti_the_inka_chess_game/app/utils/gameObjects/move.dart';
import 'package:inti_the_inka_chess_game/app/utils/gameObjects/tile.dart';

List<List<Tile>> _board(int width, int height) => List.generate(height,
    (j) => List.generate(width, (i) => Tile(chrt.empty, possession.none, i, j)));

void main() {
  group('BoardConfig', () {
    test('classic is a 3x4 board that promotes pawns to knights', () {
      expect(BoardConfig.classic.width, 3);
      expect(BoardConfig.classic.height, 4);
      expect(BoardConfig.classic.promotesTo, chrt.knight);
      expect(BoardConfig.classic.promotionRow, 3);
    });
    test('promotionRow is the far rank (height - 1)', () {
      expect(const BoardConfig(width: 5, height: 6).promotionRow, 5);
    });
    test('bossFinal is a wider 5x4 board', () {
      expect(BoardConfig.bossFinal.width, 5);
      expect(BoardConfig.bossFinal.height, 4);
      expect(BoardConfig.bossFinal.promotesTo, chrt.knight);
    });
  });

  group('createBossFinalBoard', () {
    final board = createBossFinalBoard();
    test('is 4 rows x 5 cols', () {
      expect(board.length, 4);
      expect(board.every((r) => r.length == 5), isTrue);
    });
    test('back ranks are rock, bishop, king, bishop, rock (king centered)', () {
      expect(board[0].map((t) => t.char).toList(),
          [chrt.rock, chrt.bishop, chrt.king, chrt.bishop, chrt.rock]);
      expect(board[0].every((t) => t.owner == possession.mine), isTrue);
      expect(board[3][2].char, chrt.king);
      expect(board[3].every((t) => t.owner == possession.enemy), isTrue);
    });
    test('each side has a full pawn row', () {
      expect(board[1].every((t) => t.char == chrt.pawn), isTrue);
      expect(board[2].every((t) => t.char == chrt.pawn), isTrue);
    });
  });

  // Promotion happens in GameState.transformPawn, which now reads the config
  // instead of the hardcoded `j == 3` / knight.
  group('pawn promotion follows the board config', () {
    test('classic: a pawn reaching the last row becomes a knight', () {
      final board = _board(3, 4);
      board[2][1] = Tile(chrt.pawn, possession.mine, 1, 2);
      final gs = GameState.named(
          board: board, myGraveyard: <Tile>[], enemyGraveyard: <Tile>[]);
      gs.changeGameState(Move(board[2][1], board[3][1]));
      expect(board[3][1].char, chrt.knight);
    });
    test('classic: a pawn short of the last row stays a pawn', () {
      final board = _board(3, 4);
      board[1][1] = Tile(chrt.pawn, possession.mine, 1, 1);
      final gs = GameState.named(
          board: board, myGraveyard: <Tile>[], enemyGraveyard: <Tile>[]);
      gs.changeGameState(Move(board[1][1], board[2][1]));
      expect(board[2][1].char, chrt.pawn);
    });
    test('a shorter config promotes on its own far rank', () {
      final board = _board(3, 3); // height 3 -> promotionRow 2
      board[1][1] = Tile(chrt.pawn, possession.mine, 1, 1);
      final gs = GameState.named(
        board: board,
        myGraveyard: <Tile>[],
        enemyGraveyard: <Tile>[],
        config: const BoardConfig(width: 3, height: 3),
      );
      gs.changeGameState(Move(board[1][1], board[2][1]));
      expect(board[2][1].char, chrt.knight);
    });
  });
}
