import '../data/enums.dart';
import '../utils/gameObjects/gameState.dart';
import '../utils/gameObjects/move.dart';
import '../utils/gameObjects/tile.dart';

/// Pure minichess rules engine.
///
/// This library is intentionally free of Flutter / GetX / audio / IO imports so
/// it can be unit-tested in isolation and reused by future game modes
/// (rule modifiers, campaign/boss AI). Movement is data-driven via
/// [pieceOffsets]. See the characterization tests in `test/engine/`.

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

/// Relative `[di, dj]` steps a piece may take, from the perspective of its
/// owner: `mine` advances toward +j, `enemy` toward -j, so direction-dependent
/// pieces (pawn, knight) mirror automatically. The king's steps are gated
/// separately by [hardSearchMove]; queen and empty have no moves.
///
/// This table is the single source of truth for movement — swap/extend it to
/// add rule modifiers or new pieces.
List<List<int>> pieceOffsets(chrt piece, possession owner) {
  final fwd = owner == possession.mine ? 1 : -1;
  switch (piece) {
    case chrt.pawn:
      return [
        [0, fwd]
      ];
    case chrt.knight:
      // Invented piece (a promoted pawn): pushes forward — straight plus both
      // forward diagonals — plus the two sides and a single step back.
      return [
        [0, fwd],
        [1, 0],
        [-1, 0],
        [0, -fwd],
        [1, fwd],
        [-1, fwd],
      ];
    case chrt.bishop:
      return const [
        [1, 1],
        [1, -1],
        [-1, 1],
        [-1, -1],
      ];
    case chrt.rock:
      return const [
        [1, 0],
        [-1, 0],
        [0, 1],
        [0, -1],
      ];
    case chrt.king:
      return const [
        [1, 0],
        [-1, 0],
        [0, 1],
        [0, -1],
        [1, 1],
        [1, -1],
        [-1, 1],
        [-1, -1],
      ];
    case chrt.empty:
    case chrt.queen:
      return const [];
  }
}

bool isValidMovmentPerPiece(Move m, GameState gs, [bool hard = false]) {
  final di = m.finalTile.i! - m.initialTile.i!;
  final dj = m.finalTile.j! - m.initialTile.j!;
  final reachable = pieceOffsets(m.initialTile.char, m.initialTile.owner)
      .any((o) => o[0] == di && o[1] == dj);
  if (!reachable) return false;
  // The king is the only piece whose move can be rejected — and only when
  // `hard` is false (the AI's look-ahead, so it won't step its king onto a
  // losing square). Every other piece may move into danger freely: this game
  // has no check, you win by capturing the king.
  if (m.initialTile.char == chrt.king) {
    return hardSearchMove(m, gs, hard);
  }
  return true;
}

bool checkIfWin(Move move) {
  return move.finalTile.char == chrt.king;
}
