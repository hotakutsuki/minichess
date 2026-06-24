import '../data/enums.dart';
import '../utils/gameObjects/gameState.dart';
import '../utils/gameObjects/move.dart';
import '../utils/gameObjects/tile.dart';

/// Pure minichess rules engine.
///
/// This library is intentionally free of Flutter / GetX / audio / IO imports so
/// it can be unit-tested in isolation and reused by future game modes
/// (rule modifiers, campaign/boss AI). Behaviour here is a verbatim extraction
/// of the original logic that lived in `utils.dart` — see the characterization
/// tests in `test/engine/` before changing any of it.

bool isFromGraveyard(Tile tile) {
  return tile.i == null;
}

List<Tile> getMyPieces(GameState gameState) {
  List<Tile> myPieces = [];
  myPieces.addAll(gameState.myGraveyard);
  for (var row in gameState.board) {
    myPieces.addAll(row.where((t) => t.owner == possession.mine));
  }
  return myPieces;
}

List<Tile> getEnemyPieces(GameState gameState) {
  List<Tile> enemyPieces = [];
  enemyPieces.addAll(gameState.enemyGraveyard);
  for (var row in gameState.board) {
    enemyPieces.addAll(row.where((t) => t.owner == possession.enemy));
  }
  return enemyPieces;
}

/// Whether the side to move currently has its king attacked.
///
/// Pure equivalent of `AiController.isInCheck` — extracted so the rules engine
/// no longer reaches into GetX (`Get.put(AiController())`) just to validate a
/// king move.
bool isInCheck(GameState gs) {
  for (var enemyTile in getEnemyPieces(gs)) {
    for (var row in gs.board) {
      for (var tile in row) {
        Move m = Move(enemyTile, tile);
        if (checkIfValidMove(m, gs, true) && tile.char == chrt.king) {
          return true;
        }
      }
    }
  }
  return false;
}

bool hardSearchMove(Move move, GameState gs, bool hard) {
  if (hard) {
    return true;
  }
  GameState newGameState = GameState.clone(gs);
  newGameState.changeGameState(move);
  return !isInCheck(newGameState);
}

bool isProtecting(Move m, GameState gs, bool hard) {
  if (isFromGraveyard(m.initialTile) ||
      m.initialTile.owner != m.finalTile.owner) {
    return false;
  }
  return isValidMovmentPerPiece(m, gs, hard);
}

bool checkIfValidMove(Move m, GameState gs, [bool hard = false]) {
  //TODO: Enhace: check if is players turn, and check of move have initial and final tile
  if (isFromGraveyard(m.initialTile)) {
    return m.finalTile.char == chrt.empty;
  } else {
    if (m.initialTile.owner == m.finalTile.owner) {
      return false;
    } else {
      return isValidMovmentPerPiece(m, gs, hard);
    }
  }
}

bool isValidMovmentPerPiece(Move m, GameState gs, [bool hard = false]) {
  switch (m.initialTile.char) {
    case chrt.pawn:
      if (m.initialTile.owner == possession.mine) {
        return m.initialTile.i! == m.finalTile.i &&
            m.initialTile.j == (m.finalTile.j! - 1);
      } else {
        return m.initialTile.i! == m.finalTile.i &&
            m.initialTile.j == (m.finalTile.j! + 1);
      }
    case chrt.king:
      return (m.initialTile.i! + 1 == m.finalTile.i &&
              m.initialTile.j! + 1 == m.finalTile.j &&
              hardSearchMove(m, gs, hard)) ||
          (m.initialTile.i! + 1 == m.finalTile.i &&
              m.initialTile.j == m.finalTile.j &&
              hardSearchMove(m, gs, hard)) ||
          (m.initialTile.i! + 1 == m.finalTile.i &&
              m.initialTile.j! - 1 == m.finalTile.j &&
              hardSearchMove(m, gs, hard)) ||
          (m.initialTile.i == m.finalTile.i &&
              m.initialTile.j! + 1 == m.finalTile.j &&
              hardSearchMove(m, gs, hard)) ||
          (m.initialTile.i == m.finalTile.i &&
              m.initialTile.j! - 1 == m.finalTile.j &&
              hardSearchMove(m, gs, hard)) ||
          (m.initialTile.i! - 1 == m.finalTile.i &&
              m.initialTile.j! + 1 == m.finalTile.j &&
              hardSearchMove(m, gs, hard)) ||
          (m.initialTile.i! - 1 == m.finalTile.i &&
              m.initialTile.j == m.finalTile.j &&
              hardSearchMove(m, gs, hard)) ||
          (m.initialTile.i! - 1 == m.finalTile.i &&
              m.initialTile.j! - 1 == m.finalTile.j &&
              hardSearchMove(m, gs, hard));
    case chrt.bishop:
      return (m.initialTile.i! + 1 == m.finalTile.i &&
              m.initialTile.j! + 1 == m.finalTile.j) ||
          (m.initialTile.i! + 1 == m.finalTile.i &&
              m.initialTile.j! - 1 == m.finalTile.j) ||
          (m.initialTile.i! - 1 == m.finalTile.i &&
              m.initialTile.j! + 1 == m.finalTile.j) ||
          (m.initialTile.i! - 1 == m.finalTile.i &&
              m.initialTile.j! - 1 == m.finalTile.j);
    case chrt.rock:
      return (m.initialTile.i! + 1 == m.finalTile.i &&
              m.initialTile.j == m.finalTile.j) ||
          (m.initialTile.i == m.finalTile.i &&
              m.initialTile.j! + 1 == m.finalTile.j) ||
          (m.initialTile.i == m.finalTile.i &&
              m.initialTile.j! - 1 == m.finalTile.j) ||
          (m.initialTile.i! - 1 == m.finalTile.i &&
              m.initialTile.j == m.finalTile.j);
    case chrt.knight:
      if (m.initialTile.owner == player.white) {
        return (m.initialTile.j! + 1 == m.finalTile.j &&
                m.initialTile.i == m.finalTile.i) ||
            (m.initialTile.j == m.finalTile.j &&
                m.initialTile.i! + 1 == m.finalTile.i) ||
            (m.initialTile.j == m.finalTile.j &&
                m.initialTile.i! - 1 == m.finalTile.i) ||
            (m.initialTile.j! - 1 == m.finalTile.j &&
                m.initialTile.i == m.finalTile.i) ||
            (m.initialTile.j! - 1 == m.finalTile.j &&
                m.initialTile.i! + 1 == m.finalTile.i) ||
            (m.initialTile.j! - 1 == m.finalTile.j &&
                m.initialTile.i! - 1 == m.finalTile.i);
      } else {
        return (m.initialTile.j! + 1 == m.finalTile.j &&
                m.initialTile.i == m.finalTile.i) ||
            (m.initialTile.j == m.finalTile.j &&
                m.initialTile.i! + 1 == m.finalTile.i) ||
            (m.initialTile.j == m.finalTile.j &&
                m.initialTile.i! - 1 == m.finalTile.i) ||
            (m.initialTile.j! - 1 == m.finalTile.j &&
                m.initialTile.i == m.finalTile.i) ||
            (m.initialTile.j! + 1 == m.finalTile.j &&
                m.initialTile.i! + 1 == m.finalTile.i) ||
            (m.initialTile.j! + 1 == m.finalTile.j &&
                m.initialTile.i! - 1 == m.finalTile.i);
      }
    case chrt.empty:
      return false;
    case chrt.queen:
      return false;
  }
}

bool checkIfWin(Move move) {
  return move.finalTile.char == chrt.king;
}
