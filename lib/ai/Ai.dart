
import 'package:minichess/utils/Enums.dart';
import 'package:minichess/utils/utils.dart';
import '../doms/GameState.dart';
import '../doms/Move.dart';
import '../doms/Tile.dart';

rotateMatrix(List<String> matrix){

}

List<String> getStateKeyFromBoard(GameState gs){
  //0 - pawn in my graveyard
  //1 - rock in my graveyard
  //2 - bishop in my graveyard
  //3 - knight in my graveyard
  //4 - 15 board: p:pawn r:rock b:bishop k:knight e:empty // m:my e:enemy
  //16 - pawn in enemy graveyard
  //17 - pawn in enemy graveyard
  //18 - pawn in enemy graveyard
  //19 - pawn in enemy graveyard

  List<String> stateKey = [];

  stateKey.add(gs.myGraveyard.any((t) => t.char == character.pawn) ? '1' : '0');
  stateKey.add(gs.myGraveyard.any((t) => t.char == character.rock) ? '1' : '0');
  stateKey.add(gs.myGraveyard.any((t) => t.char == character.bishop) ? '1' : '0');
  stateKey.add(gs.myGraveyard.any((t) => t.char == character.knight) ? '1' : '0');
  for (var row in gs.board) {
    for (var v in row) {
      stateKey.add('${v.char.name[0]}${v.owner == gs.playersTurn ? 'm' : 'e'}');
    }
  }
  stateKey.add(gs.enemyGraveyard.any((t) => t.char == character.pawn) ? '1' : '0');
  stateKey.add(gs.enemyGraveyard.any((t) => t.char == character.rock) ? '1' : '0');
  stateKey.add(gs.enemyGraveyard.any((t) => t.char == character.bishop) ? '1' : '0');
  stateKey.add(gs.enemyGraveyard.any((t) => t.char == character.knight) ? '1' : '0');

  return stateKey;
}


Move getPlay(GameState gameState){
  List<String> stateKey = getStateKeyFromBoard(gameState);
  if (isNewState(stateKey)){
    return makeDecision(gameState);
  }
  return getRemotePlay();
}

isNewState(List<String> stateKey){
  return true;
}

getRemotePlay(){

}

Move makeDecision(GameState gameState){
  List<Tile> myPieces = getMyPieces(gameState);
  Tile myPiece = getRandomObject(myPieces);
  List<Move> myMoves = getMoves(myPiece, gameState);
  if (myMoves.isNotEmpty){
    return getRandomObject(myMoves);
  }
  return makeDecision(gameState);
}

List<Tile> getMyPieces(GameState gameState){
  List<Tile> myPieces = [];
  myPieces.addAll(gameState.myGraveyard);
  gameState.board.forEach((row) {
    myPieces.addAll(row.where((Tile t) => t.owner == gameState.playersTurn));
  });

  return myPieces;
}

List<Move> getMoves(Tile myPiece, GameState gameState){
  List<Move> moves = [];
  gameState.board.forEach((row) {
    row.forEach((tile) {
      if (checkIfValidPosition(tile, myPiece)){
        moves.add(Move(myPiece, tile));
      }
    });
  });
  return moves;
}

getRandomObject(ts){
  return ts.elementAt(getRandomInt(ts.length));
}