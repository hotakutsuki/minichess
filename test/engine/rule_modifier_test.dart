import 'package:flutter_test/flutter_test.dart';
import 'package:inti_the_inka_chess_game/app/data/enums.dart';
import 'package:inti_the_inka_chess_game/app/engine/rule_modifier.dart';
import 'package:inti_the_inka_chess_game/app/engine/rules.dart';
import 'package:inti_the_inka_chess_game/app/utils/gameObjects/gameState.dart';
import 'package:inti_the_inka_chess_game/app/utils/gameObjects/move.dart';
import 'package:inti_the_inka_chess_game/app/utils/gameObjects/tile.dart';

// Tests for the rule-modifier hook (PR 1: the movement seam).
//
// The contract: an empty modifier list leaves the engine byte-for-byte vanilla,
// and each modifier only bends movement for the side it applies to.

List<List<Tile>> _emptyBoard() => List.generate(
    4, (j) => List.generate(3, (i) => Tile(chrt.empty, possession.none, i, j)));

GameState _stateWith(List<RuleModifier> modifiers) => GameState.named(
    board: _emptyBoard(),
    myGraveyard: <Tile>[],
    enemyGraveyard: <Tile>[],
    modifiers: modifiers);

Move _move(chrt c, possession o, int i0, int j0, int i1, int j1) =>
    Move(Tile(c, o, i0, j0), Tile(chrt.empty, possession.none, i1, j1));

void main() {
  group('effectiveOffsets with no modifiers', () {
    test('returns pieceOffsets verbatim (vanilla)', () {
      final gs = _stateWith(const []);
      for (final piece in chrt.values) {
        for (final owner in [possession.mine, possession.enemy]) {
          expect(effectiveOffsets(piece, owner, gs),
              pieceOffsets(piece, owner),
              reason: '$piece/$owner');
        }
      }
    });
  });

  group('DoubleStepModifier', () {
    test('adds a 2-square option while keeping the 1-square move', () {
      final gs = _stateWith(const [DoubleStepModifier()]);
      // rock: still one step...
      expect(isValidMovmentPerPiece(
          _move(chrt.rock, possession.mine, 1, 1, 1, 2), gs, true), isTrue);
      // ...and now a two-step jump in the same direction.
      expect(isValidMovmentPerPiece(
          _move(chrt.rock, possession.mine, 1, 1, 1, 3), gs, true), isTrue);
    });

    test('does nothing without the modifier', () {
      final gs = _stateWith(const []);
      expect(isValidMovmentPerPiece(
          _move(chrt.rock, possession.mine, 1, 1, 1, 3), gs, true), isFalse);
    });

    test('side=mine leaves the enemy untouched', () {
      final gs = _stateWith(const [DoubleStepModifier(side: possession.mine)]);
      // mine gets the two-step...
      expect(isValidMovmentPerPiece(
          _move(chrt.rock, possession.mine, 1, 1, 1, 3), gs, true), isTrue);
      // ...the enemy does not.
      expect(isValidMovmentPerPiece(
          _move(chrt.rock, possession.enemy, 1, 3, 1, 1), gs, true), isFalse);
    });
  });

  group('TransformAllPiecesModifier (all become knights/osos)', () {
    final gs = _stateWith(
        const [TransformAllPiecesModifier(side: possession.mine)]);

    test('a bishop moves like a knight (straight forward, normally illegal)',
        () {
      // Vanilla bishop cannot step straight forward...
      expect(isValidMovmentPerPiece(
          _move(chrt.bishop, possession.mine, 1, 1, 1, 2),
          _stateWith(const []), true), isFalse);
      // ...but as an oso it can.
      expect(isValidMovmentPerPiece(
          _move(chrt.bishop, possession.mine, 1, 1, 1, 2), gs, true), isTrue);
    });

    test('the king is left untouched', () {
      // The knight/oso cannot step two-back-diagonally; the king still moves
      // exactly like a king (one step any direction), unchanged.
      expect(effectiveOffsets(chrt.king, possession.mine, gs),
          pieceOffsets(chrt.king, possession.mine));
    });

    test('the enemy side is untouched (side=mine)', () {
      expect(effectiveOffsets(chrt.bishop, possession.enemy, gs),
          pieceOffsets(chrt.bishop, possession.enemy));
    });
  });
}
