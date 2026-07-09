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

GameState _stateWith(List<RuleModifier> modifiers) =>
    _boardStateWith(_emptyBoard(), modifiers);

GameState _boardStateWith(
        List<List<Tile>> board, List<RuleModifier> modifiers) =>
    GameState.named(
        board: board,
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

    test('side=protagonist leaves the enemy untouched', () {
      final gs =
          _stateWith(const [DoubleStepModifier(side: ModifierSide.protagonist)]);
      // the protagonist (mine, in a default state) gets the two-step...
      expect(isValidMovmentPerPiece(
          _move(chrt.rock, possession.mine, 1, 1, 1, 3), gs, true), isTrue);
      // ...the antagonist (enemy) does not.
      expect(isValidMovmentPerPiece(
          _move(chrt.rock, possession.enemy, 1, 3, 1, 1), gs, true), isFalse);
    });

    test('a piece in between blocks the two-step leap', () {
      final b = _emptyBoard();
      b[0][1] = Tile(chrt.rock, possession.mine, 1, 0); // mover at (1,0)
      b[1][1] = Tile(chrt.pawn, possession.mine, 1, 1); // blocker at midpoint
      final gs = _boardStateWith(b, const [DoubleStepModifier()]);
      // the leap to (1,2) is vetoed because the midpoint (1,1) is occupied.
      expect(checkIfValidMove(Move(b[0][1], b[2][1]), gs, true), isFalse);
    });

    test('the two-step leap is allowed when the path is clear', () {
      final b = _emptyBoard();
      b[0][1] = Tile(chrt.rock, possession.mine, 1, 0);
      final gs = _boardStateWith(b, const [DoubleStepModifier()]);
      expect(checkIfValidMove(Move(b[0][1], b[2][1]), gs, true), isTrue);
    });

    test('stable targeting follows the protagonist across a rotation', () {
      final gs =
          _stateWith(const [DoubleStepModifier(side: ModifierSide.protagonist)]);
      gs.rotate(); // now `mine` is the antagonist, `enemy` is the protagonist
      // the protagonist is now the ENEMY-owned pieces -> they get the two-step.
      expect(isValidMovmentPerPiece(
          _move(chrt.rock, possession.enemy, 1, 1, 1, 3), gs, true), isTrue);
      expect(isValidMovmentPerPiece(
          _move(chrt.rock, possession.mine, 1, 1, 1, 3), gs, true), isFalse);
    });
  });

  group('TransformAllPiecesModifier (all become knights/osos)', () {
    final gs = _stateWith(
        const [TransformAllPiecesModifier(side: ModifierSide.protagonist)]);

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

    test('the enemy side is untouched (side=protagonist)', () {
      expect(effectiveOffsets(chrt.bishop, possession.enemy, gs),
          pieceOffsets(chrt.bishop, possession.enemy));
    });
  });

  group('ReturnCapturedModifier (invert possession of capture)', () {
    // A mine rock at (0,0) captures an enemy pawn at (0,1).
    List<List<Tile>> board() {
      final b = _emptyBoard();
      b[0][0] = Tile(chrt.rock, possession.mine, 0, 0);
      b[1][0] = Tile(chrt.pawn, possession.enemy, 0, 1);
      return b;
    }

    test('vanilla: the captor claims the captured piece', () {
      final b = board();
      final gs = _boardStateWith(b, const []);
      gs.changeGameState(Move(b[0][0], b[1][0]));
      expect(gs.myGraveyard.length, 1);
      expect(gs.myGraveyard.first.char, chrt.pawn);
      expect(gs.myGraveyard.first.owner, possession.mine);
      expect(gs.enemyGraveyard, isEmpty);
    });

    test('modifier: the captured piece returns to its owner', () {
      final b = board();
      final gs = _boardStateWith(b, const [ReturnCapturedModifier()]);
      gs.changeGameState(Move(b[0][0], b[1][0]));
      expect(gs.myGraveyard, isEmpty);
      expect(gs.enemyGraveyard.length, 1);
      expect(gs.enemyGraveyard.first.char, chrt.pawn);
      expect(gs.enemyGraveyard.first.owner, possession.enemy);
    });
  });

  group('AreaCaptureModifier (Embestida)', () {
    test('a capture also clears an orthogonally-adjacent enemy piece', () {
      final b = _emptyBoard();
      b[0][0] = Tile(chrt.rock, possession.mine, 0, 0); // mover
      b[1][0] = Tile(chrt.pawn, possession.enemy, 0, 1); // captured (landing)
      b[1][1] = Tile(chrt.bishop, possession.enemy, 1, 1); // adjacent -> cleared
      b[3][2] = Tile(chrt.rock, possession.enemy, 2, 3); // far -> untouched
      final gs = _boardStateWith(b, const [AreaCaptureModifier()]);
      gs.changeGameState(Move(b[0][0], b[1][0]));
      expect(b[1][1].char, chrt.empty); // adjacent enemy gone
      expect(b[1][1].owner, possession.none);
      expect(b[3][2].char, chrt.rock); // far enemy stays
      // captor's graveyard holds both the landed capture and the area hit.
      expect(gs.myGraveyard.length, 2);
    });

    test('no area effect when the move does not capture', () {
      final b = _emptyBoard();
      b[0][0] = Tile(chrt.rock, possession.mine, 0, 0);
      b[1][1] = Tile(chrt.bishop, possession.enemy, 1, 1); // adjacent to empty landing
      final gs = _boardStateWith(b, const [AreaCaptureModifier()]);
      gs.changeGameState(Move(b[0][0], b[1][0])); // lands on empty (0,1)
      expect(b[1][1].char, chrt.bishop); // untouched: no capture happened
      expect(gs.myGraveyard, isEmpty);
    });

    test('never removes a king (king-safe)', () {
      final b = _emptyBoard();
      b[0][0] = Tile(chrt.rock, possession.mine, 0, 0); // mover
      b[1][0] = Tile(chrt.pawn, possession.enemy, 0, 1); // captured landing
      b[1][1] = Tile(chrt.king, possession.enemy, 1, 1); // adjacent enemy KING
      final gs = _boardStateWith(b, const [AreaCaptureModifier()]);
      gs.changeGameState(Move(b[0][0], b[1][0]));
      expect(b[1][1].char, chrt.king); // survives the embestida
    });
  });

  group('TransformAll display', () {
    test('a transformed piece shows the oso (knight) sprite', () {
      final b = _emptyBoard();
      b[1][1] = Tile(chrt.bishop, possession.mine, 1, 1);
      b[0][1] = Tile(chrt.king, possession.mine, 1, 0);
      final gs = _boardStateWith(
          b, const [TransformAllPiecesModifier(side: ModifierSide.protagonist)]);
      expect(effectiveChar(b[1][1], gs), chrt.knight); // bishop shown as oso
      expect(effectiveChar(b[0][1], gs), chrt.king); // king unchanged
    });

    test('a transformed piece is buried *as* an oso (dies a knight)', () {
      final b = _emptyBoard();
      b[0][0] = Tile(chrt.rock, possession.mine, 0, 0); // captor
      b[1][0] = Tile(chrt.bishop, possession.enemy, 0, 1); // enemy, shown as oso
      final gs = _boardStateWith(
          b, const [TransformAllPiecesModifier(side: ModifierSide.antagonist)]);
      gs.changeGameState(Move(b[0][0], b[1][0]));
      expect(gs.myGraveyard.length, 1);
      // stored as a knight (oso), not the bishop it used to be.
      expect(gs.myGraveyard.first.char, chrt.knight);
    });
  });

  group('applyTurnStart with no modifiers', () {
    test('does nothing', () {
      final b = _emptyBoard();
      b[0][0] = Tile(chrt.rock, possession.mine, 0, 0);
      final gs = _boardStateWith(b, const []);
      gs.applyTurnStart();
      expect(b[0][0].char, chrt.rock);
      final occupied =
          b.expand((r) => r).where((t) => t.char != chrt.empty).length;
      expect(occupied, 1);
    });
  });

  group('SpawnModifier (Rebrote)', () {
    test('sprouts a piece on the first empty tile each turn', () {
      final b = _emptyBoard();
      b[0][0] = Tile(chrt.rock, possession.mine, 0, 0); // occupies the very first tile
      final gs = _boardStateWith(b, [SpawnModifier(piece: chrt.pawn)]);
      gs.applyTurnStart();
      // first empty scanning j=0,i=0.. is (i=1, j=0) == board[0][1]
      expect(b[0][1].char, chrt.pawn);
      expect(b[0][1].owner, possession.mine);
    });

    test('a full board spawns nothing', () {
      final b = List.generate(
          4,
          (j) => List.generate(
              3, (i) => Tile(chrt.pawn, possession.mine, i, j)));
      final gs = _boardStateWith(b, [SpawnModifier()]);
      gs.applyTurnStart(); // must not throw or overwrite
      expect(b.expand((r) => r).every((t) => t.char == chrt.pawn), isTrue);
    });
  });

  group('WindModifier (Viento)', () {
    test('blows the opponent one row back; only the opponent, off-edge to grave',
        () {
      final b = _emptyBoard();
      b[1][0] = Tile(chrt.pawn, possession.enemy, 0, 1); // -> (0,2)
      b[3][2] = Tile(chrt.rock, possession.enemy, 2, 3); // frontier -> off board
      b[1][2] = Tile(chrt.bishop, possession.mine, 2, 1); // caster's own: untouched
      final gs = _boardStateWith(b, [WindModifier(everyTurns: 1)]);
      gs.applyTurnStart();
      expect(b[2][0].char, chrt.pawn);
      expect(b[2][0].owner, possession.enemy);
      expect(b[1][0].char, chrt.empty); // origin cleared
      // rock blown off the back edge -> enemy graveyard
      expect(b[3][2].char, chrt.empty);
      expect(gs.enemyGraveyard.length, 1);
      expect(gs.enemyGraveyard.first.char, chrt.rock);
      expect(gs.enemyGraveyard.first.owner, possession.enemy);
      // the caster's own piece never moves
      expect(b[1][2].char, chrt.bishop);
      expect(gs.myGraveyard, isEmpty);
    });

    test('a packed column cascades one step (frontier first)', () {
      final b = _emptyBoard();
      b[1][1] = Tile(chrt.pawn, possession.enemy, 1, 1); // -> (1,2)
      b[2][1] = Tile(chrt.bishop, possession.enemy, 1, 2); // -> (1,3), moves first
      final gs = _boardStateWith(b, [WindModifier(everyTurns: 1)]);
      gs.applyTurnStart();
      expect(b[3][1].char, chrt.bishop);
      expect(b[2][1].char, chrt.pawn);
      expect(b[1][1].char, chrt.empty);
      expect(gs.enemyGraveyard, isEmpty); // nobody blown off
    });

    test('a piece jammed behind an anchored king holds its square', () {
      final b = _emptyBoard();
      b[2][1] = Tile(chrt.pawn, possession.enemy, 1, 2); // wants (1,3)
      b[3][1] = Tile(chrt.king, possession.enemy, 1, 3); // king dams it
      final gs = _boardStateWith(b, [WindModifier(everyTurns: 1)]);
      gs.applyTurnStart();
      expect(b[3][1].char, chrt.king); // king didn't move
      expect(b[2][1].char, chrt.pawn); // blocked -> stays
      expect(gs.enemyGraveyard, isEmpty);
    });

    test('only gusts every `everyTurns` turns', () {
      final b = _emptyBoard();
      b[1][1] = Tile(chrt.pawn, possession.enemy, 1, 1);
      final gs = _boardStateWith(b, [WindModifier(everyTurns: 3)]);
      gs.applyTurnStart(); // 1
      gs.applyTurnStart(); // 2 — no gust yet
      expect(b[1][1].char, chrt.pawn);
      gs.applyTurnStart(); // 3 — gust
      expect(b[2][1].char, chrt.pawn);
      expect(b[1][1].char, chrt.empty);
    });

    test('an enemy king on the frontier is anchored — never blown off', () {
      final b = _emptyBoard();
      b[3][0] = Tile(chrt.king, possession.enemy, 0, 3); // frontier: would blow off
      final gs = _boardStateWith(b, [WindModifier(everyTurns: 1)]);
      gs.applyTurnStart();
      expect(b[3][0].char, chrt.king); // still there
      expect(gs.enemyGraveyard, isEmpty);
    });
  });

  group('WitherModifier (Marchitar)', () {
    test('a piece unmoved for `turns` turns withers to the graveyard', () {
      final b = _emptyBoard();
      b[1][1] = Tile(chrt.bishop, possession.mine, 1, 1);
      final gs = _boardStateWith(b, const [WitherModifier(turns: 2)]);
      gs.applyTurnStart(); // idle 1
      expect(b[1][1].char, chrt.bishop);
      gs.applyTurnStart(); // idle 2 -> withers
      expect(b[1][1].char, chrt.empty);
      expect(gs.myGraveyard.length, 1);
      expect(gs.myGraveyard.first.char, chrt.bishop);
    });

    test('moving a piece resets its wither clock', () {
      final b = _emptyBoard();
      b[1][1] = Tile(chrt.rock, possession.mine, 1, 1);
      final gs = _boardStateWith(b, const [WitherModifier(turns: 2)]);
      gs.applyTurnStart(); // idle 1
      gs.changeGameState(Move(b[1][1], b[2][1])); // move (1,1)->(1,2): resets
      gs.applyTurnStart(); // idle 1 again (on the new tile)
      expect(b[2][1].char, chrt.rock); // still alive
      expect(gs.myGraveyard, isEmpty);
    });

    test('the king never withers', () {
      final b = _emptyBoard();
      b[1][1] = Tile(chrt.king, possession.mine, 1, 1);
      final gs = _boardStateWith(b, const [WitherModifier(turns: 1)]);
      gs.applyTurnStart();
      gs.applyTurnStart();
      expect(b[1][1].char, chrt.king);
    });
  });

  group('FelledTilesModifier (Tala dinámica)', () {
    test('seeds a felled square the protagonist cannot enter (antagonist can)',
        () {
      final gs = _boardStateWith(_emptyBoard(), const [FelledTilesModifier()]);
      gs.applyTurnStart(); // seeds the centre: board[2][1] == (i=1, j=2)
      expect(gs.board[2][1].felledTurns, greaterThan(0));
      // protagonist (mine, default state) blocked; antagonist allowed.
      expect(checkIfValidMove(
          _move(chrt.rock, possession.mine, 1, 1, 1, 2), gs, true), isFalse);
      expect(checkIfValidMove(
          _move(chrt.rock, possession.enemy, 1, 1, 1, 2), gs, true), isTrue);
    });

    test('a felled square counts down and expires', () {
      final b = _emptyBoard();
      b[0][0].felledTurns = 1; // a felled corner, far from the centre seed
      final gs = _boardStateWith(b, const [FelledTilesModifier(duration: 2)]);
      gs.applyTurnStart(); // decrements the corner 1 -> 0 (then seeds the centre)
      expect(b[0][0].felledTurns, 0);
    });

    test('spreads to a neighbour on later turns', () {
      final gs = _boardStateWith(_emptyBoard(), const [FelledTilesModifier()]);
      gs.applyTurnStart(); // seed centre
      gs.applyTurnStart(); // spread to a neighbour
      final felled =
          gs.board.expand((r) => r).where((t) => t.felledTurns > 0).length;
      expect(felled, greaterThanOrEqualTo(2));
    });
  });
}
