import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../data/enums.dart';
import '../../../data/remoteRecord.dart';
import '../../../utils/gameObjects/GameState.dart';
import '../../../utils/gameObjects/move.dart';
import '../../../utils/gameObjects/tile.dart';
import '../../../utils/utils.dart';

class AiController extends GetxController {
  static const String docsDomain = 'docs.google.com';
  static const String DOC_URL =
      '/forms/d/e/1FAIpQLSf99qDW5LEo3xsWQeQo20MIw0XBAuLf4taufSMkMyUWoWCpJg';
  static const String POST_URL = '/formResponse';
  static const String QUERY_URL =
      '/spreadsheets/d/1oaRkah35SbiQ6kNWfQLNQEOLCHFIDHxVxdcxaaMWpz4/gviz/tq';
  static const String usp = 'usp';
  static const String ppurl = 'pp_url';
  static const String boardEntry = 'entry.1551786230';
  static const String movEntry = 'entry.390386129';
  static const String victoryEntry = 'entry.888995238';
  static const String matchIdEntry = 'entry.423913528';
  static const String metadatoEntry = 'entry.196101266';

  storeMovemntHistory(
    List<String> boardHistory,
    List<Move> whiteHistory,
    List<Move> blackHistory,
    player winner,
  ) async {
    List<RemoteRecord> records = createRemoteHistoryArray(
        boardHistory, whiteHistory, blackHistory, winner);
    records.map((record) {
      var url = Uri.https(docsDomain, '$DOC_URL$POST_URL', {
        usp: ppurl,
        boardEntry: record.boardstate,
        movEntry: record.mov,
        victoryEntry: record.victory,
        matchIdEntry: record.matchid,
        metadatoEntry: '',
      });
      // print(url);
      http.get(url);
    }).toList();
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
      records.add(createRecord(boardHistory[i + j], whiteHistory[i], matchId,
          winner == player.white, player.white));
      i++;
      if (boardHistory.length > i + j) {
        records.add(createRecord(boardHistory[i + j], blackHistory[j], matchId,
            winner == player.black, player.black));
        j++;
      }
    }
    // print(records);
    return records;
  }

  RemoteRecord createRecord(String gameState, Move move, String matchId,
      bool winner, player playersTurn) {
    return RemoteRecord(
        gameState, move.getMoveCode(), winner ? '1' : '0', matchId);
  }

  Move? getCheckMate(GameState gs) {
    Move? move;
    getMyPieces(gs).forEach((p) {
      getMoves(p, gs, true).forEach((m) {
        if (m.finalTile.char == chrt.king) {
          move = m;
        }
      });
    });
    return move;
  }

  bool isInCheck(GameState gs) {
    bool isInCheck = false;
    for (var enemyTile in getEnemyPieces(gs)) {
      for (var row in gs.board) {
        for (var tile in row) {
          Move m = Move(enemyTile, tile);
          if (checkIfValidMove(m, gs, true) && tile.char == chrt.king) {
            isInCheck = true;
          }
        }
      }
    }
    return isInCheck;
  }

  bool isInEnemyCheck(GameState gs) {
    bool isInCheck = false;
    for (var myTile in getMyPieces(gs)) {
      for (var row in gs.board) {
        for (var tile in row) {
          Move m = Move(myTile, tile);
          if (checkIfValidMove(m, gs, true) && tile.char == chrt.king) {
            isInCheck = true;
          }
        }
      }
    }
    return isInCheck;
  }

  Tile? getTileMakingCheck(GameState gs) {
    for (var myTile in getMyPieces(gs)) {
      for (var row in gs.board) {
        for (var tile in row) {
          Move m = Move(myTile, tile);
          if (checkIfValidMove(m, gs, true) && tile.char == chrt.king) {
            return myTile;
          }
        }
      }
    }
    return null;
  }

  Move? runFromCheckmate(GameState gameState) {
    List<Tile> myPieces = getMyPieces(gameState);
    Move? result;
    List<Move> moves = [];
    for (var myPiece in myPieces) {
      List<Move> myMoves = getMoves(myPiece, gameState);
      for (var move in myMoves) {
        GameState newGameState = GameState.clone(gameState);
        newGameState.changeGameState(move);
        if (!isInCheck(newGameState)) {
          // print('found a move');
          moves.add(move);
        }
      }
    }
    if (moves.isNotEmpty) {
      result = bestEvaluatedMove(gameState, moves);
      // result = getRandomObject(moves);
      // print('result:$result');
    }
    return result;
  }

  Future<Move> getPlay(GameState gameState, gameMode gamemode) async {
    Move? checkMate = getCheckMate(gameState);
    if (checkMate != null) {
      return checkMate;
    }

    if (isInCheck(gameState)) {
      print('im in check');
      Move? runFromCheckMate = runFromCheckmate(gameState);
      if (runFromCheckMate != null) {
        return runFromCheckMate;
      }
    }
    if (!(await isConnected())) {
      print('Playing without internet...');
      return makeLocalDecision(gameState);
    }

    String stateKey = gameState.toString();

    List<String> remotePlaysResponse = await fetchRemotePlays(stateKey);
    if (isNewState(remotePlaysResponse)) {
      print('Playing locally...');
      Move move = makeLocalDecision(gameState);
      // print(move);
      return move;
    }
    if (gamemode == gameMode.training && getRandomInt(5) == 0) {
      print('Forcing locally by luck');
      return makeLocalDecision(gameState);
      // print(move);
    } else {
      print('Playing remotely...');
      return getRemotePlay(remotePlaysResponse, gameState);
      // print(move);
    }
  }

  isNewState(List<String> remotePlays) {
    return remotePlays.isEmpty;
  }

  Future<List<String>> fetchRemotePlays(String stateKey) async {
    List<String> remotePlays = [];
    var uri = Uri.https(docsDomain, QUERY_URL, {
      'tq': 'select C where B = \'$stateKey\' and D = 1',
    });
    // print('\nuri');
    // print(uri);
    http.Response response;
    try {
      response = await http.get(uri);
    } catch (e) {
      print('Network error. playing random');
      return remotePlays;
    }
    if (response.statusCode != 200) {
      print('Response Status code error: ${response.statusCode}');
      return remotePlays;
    }
    RegExp exp = RegExp(
      r"(^\/\*O_o\*\/([\s\S]*[\n\r]*)google\.visualization\.Query\.setResponse\(|\);$)",
    );
    String ans = response.body.replaceAll(exp, '');
    if (ans.isEmpty) {
      return remotePlays;
    }

    Map<String, dynamic> map = jsonDecode(response.body.replaceAll(exp, ''));
    if (map['table']?['rows']?.length <= 0) {
      return remotePlays;
    }
    map['table']['rows'].forEach((c) {
      remotePlays.add(c['c'][0]['v'].toString());
    });
    return remotePlays;
  }

  Move getRemotePlay(List<String> remotePlaysReponse, GameState gs) {
    List<Move> remoteMoves = remotePlaysReponse.map((resp) {
      var spliced = resp.split('|');
      if (isInt(spliced[0])) {
        return Move(gs.board[int.parse(spliced[1])][int.parse(spliced[0])],
            gs.board[int.parse(spliced[3])][int.parse(spliced[2])]);
      }
      chrt char = getCharFromInitials(spliced[0]);
      Tile initialTile = gs.myGraveyard.firstWhere((t) => t.char == char);
      Tile finalTile = gs.board[int.parse(spliced[3])][int.parse(spliced[2])];
      return Move(initialTile, finalTile);
    }).toList();
    // print(remoteMoves);
    return getRandomObject(remoteMoves);
  }

  chrt getCharFromInitials(String initials) {
    return chrt.values.firstWhere((element) => element.name == initials);
  }

  bool isInt(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  Move makeLocalDecision(GameState gameState, [bool hard = false]) {
    if (hard) {
      print("checking hard...");
    }
    List<Tile> myPieces = getMyPieces(gameState);
    List<Move> allMoves = [];
    for (var myPiece in myPieces) {
      List<Move> myMoves = getMoves(myPiece, gameState, hard);
      allMoves.addAll(myMoves);
    }
    if (allMoves.isNotEmpty) {
      return bestEvaluatedMove(gameState, allMoves);
      // return getRandomObject(allMoves);
    }
    return makeLocalDecision(gameState, true);
  }

  Move bestEvaluatedMove(GameState gs, List<Move> allMoves) {
    print('getting bestMoves');
    List<int> califications = [];
    for (var value in allMoves) {
      print('Evaluating: $value');
      califications
          .add(evaluateState(GameState.clone(gs).changeGameState(value)));
    }

    allMoves.asMap().forEach((i, move) {
      print('$move -> ${califications[i]}');
    });

    //TODO: Easy:

    int minQualification = califications[0];
    califications.asMap().forEach((i, score) {
      if (score < minQualification) {
        minQualification = score;
      }
    });
    //normalizate scores
    List<num> normalizedQuadraticCalifications = [];
    califications.asMap().forEach((i, score) {
      normalizedQuadraticCalifications.add(pow(score - minQualification, 2) );
    });
    print('normalizedQuadraticCalifications: $normalizedQuadraticCalifications');
    //create pool
    List<Move> pool = [];
    normalizedQuadraticCalifications.asMap().forEach((i, score) {
      for (int idx = 0; idx < score; idx++){ //added at least once
        pool.add(allMoves[i]);
      }
    });
    if (pool.isNotEmpty){
      return getRandomObject(pool);
    }
    return getRandomObject(allMoves);

    //Hard:
    /* int maxQualification = califications[0];
    califications.asMap().forEach((i, score) {
      if (score > maxQualification) {
        maxQualification = score;
      }
    });
    //create pool
    List<Move> pool = [];
    califications.asMap().forEach((i, score) {
      if (score == maxQualification){
        pool.add(allMoves[i]);
      }
    });
    print('pool: $pool');
    return getRandomObject(pool);*/
  }

  List<Tile> getEnemyPieces(GameState gameState) {
    List<Tile> enemyPieces = [];
    enemyPieces.addAll(gameState.enemyGraveyard);
    for (var row in gameState.board) {
      enemyPieces.addAll(row.where((t) => t.owner == possession.enemy));
    }
    return enemyPieces;
  }

  List<Tile> getMyPieces(GameState gameState) {
    List<Tile> myPieces = [];
    myPieces.addAll(gameState.myGraveyard);
    for (var row in gameState.board) {
      myPieces.addAll(row.where((t) => t.owner == possession.mine));
    }

    return myPieces;
  }

  List<Move> getMoves(Tile myPiece, GameState gameState, [bool hard = false]) {
    List<Move> moves = [];
    for (var row in gameState.board) {
      for (var tile in row) {
        Move m = Move(myPiece, tile);
        if (checkIfValidMove(m, gameState, hard)) {
          moves.add(m);
        }
      }
    }
    return moves;
  }

  int evaluateState(GameState gs) {
    int piecesWeight = 3;
    int protectionWeight = 3;
    int attackWeight = 1;
    int protectionEnemy = 1;
    int attackEnemyWeight = 3;
    int checkWeight = 8;

    int score1 = (getMyPieces(gs).length - getEnemyPieces(gs).length) * piecesWeight;
    int score2 = getProtectedLinksNumber(gs) * protectionWeight;
    int score3 = getAttackedPieces(gs) * attackWeight;
    int score4 = - getProtectedEnemyLinksNumber(gs) * protectionEnemy;
    int score5 = - getAttackedEnemyPieces(gs) * attackEnemyWeight;
    int score6 = 0;
    Tile? makingCheck = getTileMakingCheck(gs);
    if (makingCheck != null && isProtected(gs, makingCheck)){
      score6 = 2 * checkWeight;
    }

    print('$score1 Pieces + $score2 links + $score3 attacks + $score4 EnemyLinks + $score5 EnemyAttacks + $score6 efectiveCheck = ${score1 + score2 + score3 + score4 + score5 + score6}');
    return score1 + score2 + score3 + score4 + score5 + score6;
  }

  int getAttackedPieces(gs){
    int attacked = 0;
    for (var myTile in getMyPieces(gs)) {
      for (var row in gs.board) {
        for (Tile tile in row) {
          Move m = Move(myTile, tile);
          if (checkIfValidMove(m, gs, true) && tile.owner == possession.enemy) {
            attacked++;
          }
        }
      }
    }
    return attacked;
  }

  int getAttackedEnemyPieces(gs){
    int attacked = 0;
    for (var enemyTile in getEnemyPieces(gs)) {
      for (var row in gs.board) {
        for (Tile tile in row) {
          Move m = Move(enemyTile, tile);
          if (checkIfValidMove(m, gs, true) && tile.owner == possession.mine) {
            attacked++;
          }
        }
      }
    }
    return attacked;
  }

  int getProtectedLinksNumber(gs){
    List<Tile> protectedTiles = [];
    for (var myTile in getMyPieces(gs)) {
      for (var row in gs.board) {
        for (Tile tile in row) {
          Move m = Move(myTile, tile);
          if (isProtecting(m,gs) && tile.char!=chrt.king) { //king does not need protection
            protectedTiles.addIf(!protectedTiles.contains(tile), tile);
          }
        }
      }
    }
    return protectedTiles.length;
  }

  bool isProtected(GameState gs, Tile makingCheckTile){
    bool isProtected = false;
    for (var myTile in getMyPieces(gs)) {
      for (var row in gs.board) {
        for (Tile tile in row) {
          Move m = Move(myTile, tile);
          if (isProtecting(m,gs) && makingCheckTile == tile) {
            isProtected = true;
          }
        }
      }
    }
    return isProtected;
  }

  int getProtectedEnemyLinksNumber(gs){
    int links = 0;
    for (var enemyTile in getEnemyPieces(gs)) {
      for (var row in gs.board) {
        for (Tile tile in row) {
          Move m = Move(enemyTile, tile);
          if (isProtecting(m,gs)) {
            links++;
          }
        }
      }
    }
    return links;
  }

  getRandomObject(ts) {
    return ts.elementAt(getRandomInt(ts.length));
  }
}
