import 'package:minichess/doms/RemoteRecord.dart';
import 'package:minichess/utils/Enums.dart';
import 'package:minichess/utils/utils.dart';
import '../doms/GameState.dart';
import '../doms/Move.dart';
import '../doms/Tile.dart';

rotateMatrix(List<String> matrix) {}

storeMovemntHistory(
  List<String> boardHistory,
  List<Move> whiteHistory,
  List<Move> blackHistory,
  player winner,
) {
  List<RemoteRecord> records = createRemoteHistoryArray(
      boardHistory, whiteHistory, blackHistory, winner);
}

List<RemoteRecord> createRemoteHistoryArray(
  List<String> boardHistory,
  List<Move> whiteHistory,
  List<Move> blackHistory,
  player winner,
) {
  String matchId = DateTime.now().millisecondsSinceEpoch.toString();
  List<RemoteRecord> records = [];
  int i = 0, j = 0;
  while (i + j < boardHistory.length) {
    records.add(createRecord(
        boardHistory[i + j], whiteHistory[i], matchId, winner == player.white));
    i++;
    if (boardHistory.length > i + j) {
      records.add(createRecord(boardHistory[i + j], blackHistory[j], matchId,
          winner == player.black));
      j++;
    }
  }
  print(records);
  return records;
}

RemoteRecord createRecord(
    String gameState, Move move, String matchId, bool winner) {
  return RemoteRecord(
      gameState, move.getMoveCode(), winner ? '1' : '0', matchId);
}

Move getPlay(GameState gameState) {
  List<String> stateKey = gameState.getStateKey();
  if (isNewState(stateKey)) {
    return makeDecision(gameState);
  }
  return getRemotePlay();
}

isNewState(List<String> stateKey) {
  return true;
}

getRemotePlay() {}

Move makeDecision(GameState gameState) {
  List<Tile> myPieces = getMyPieces(gameState);
  Tile myPiece = getRandomObject(myPieces);
  List<Move> myMoves = getMoves(myPiece, gameState);
  if (myMoves.isNotEmpty) {
    return getRandomObject(myMoves);
  }
  return makeDecision(gameState);
}

List<Tile> getMyPieces(GameState gameState) {
  List<Tile> myPieces = [];
  myPieces.addAll(gameState.myGraveyard);
  for (var row in gameState.board) {
    myPieces.addAll(row.where((Tile t) => t.owner == gameState.playersTurn));
  }

  return myPieces;
}

List<Move> getMoves(Tile myPiece, GameState gameState) {
  List<Move> moves = [];
  for (var row in gameState.board) {
    for (var tile in row) {
      if (checkIfValidPosition(tile, myPiece)) {
        moves.add(Move(myPiece, tile, gameState.playersTurn));
      }
    }
  }
  return moves;
}

getRandomObject(ts) {
  return ts.elementAt(getRandomInt(ts.length));
}
