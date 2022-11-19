import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minichess/doms/RemoteRecord.dart';
import 'package:minichess/utils/Enums.dart';
import 'package:minichess/utils/utils.dart';
import '../doms/GameState.dart';
import '../doms/Move.dart';
import '../doms/Tile.dart';

const String docsDomain = 'docs.google.com';
const String DOC_URL =
    '/forms/d/e/1FAIpQLSf99qDW5LEo3xsWQeQo20MIw0XBAuLf4taufSMkMyUWoWCpJg';
const String POST_URL = '/formResponse';
const String QUERY_URL =
    '/spreadsheets/d/1oaRkah35SbiQ6kNWfQLNQEOLCHFIDHxVxdcxaaMWpz4/gviz/tq';
const String usp = 'usp';
const String ppurl = 'pp_url';
const String boardEntry = 'entry.1551786230';
const String movEntry = 'entry.390386129';
const String victoryEntry = 'entry.888995238';
const String matchIdEntry = 'entry.423913528';
const String metadatoEntry = 'entry.196101266';

rotateMatrix(List<String> matrix) {}

storeMovemntHistory(
  List<String> boardHistory,
  List<Move> whiteHistory,
  List<Move> blackHistory,
  player winner,
) async {
  List<RemoteRecord> records = createRemoteHistoryArray(
      boardHistory, whiteHistory, blackHistory, winner);
  List<Future> futures = records.map((record) {
    var url = Uri.https(docsDomain, '$DOC_URL$POST_URL', {
      usp: ppurl,
      boardEntry: record.boardstate,
      movEntry: record.mov,
      victoryEntry: record.victory,
      matchIdEntry: record.matchid,
      metadatoEntry: '',
    });
    // print(url);
    return http.get(url);
  }).toList();
  await Future.wait(futures);
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
    getMoves(p, gs).forEach((m) {
      if (m.finalTile.char == chrt.king) {
        move = m;
      }
    });
  });
  return move;
}

Future<Move> getPlay(GameState gameState) async {
  Move? checkMate = getCheckMate(gameState);
  if (checkMate != null) {
    return checkMate;
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
  if (gameState.gamemode == gameMode.training && getRandomIO() == 0) {
    print('Forcing locally by luck');
    return makeLocalDecision(gameState);
    // print(move);
  } else {
    print('Playing remotely...');
    print(gameState);
    return getRemotePlay(remotePlaysResponse, gameState);
    // print(move);
  }
}

isNewState(List<String> remotePlays) {
  return remotePlays.length <= 0;
}

Future<List<String>> fetchRemotePlays(String stateKey) async {
  List<String> remotePlays = [];
  var uri = Uri.https(docsDomain, QUERY_URL, {
    'tq': 'select C where B = \'$stateKey\' and D = 1',
  });
  print('\nuri');
  print(uri);
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
      if (gs.playersTurn == player.white) {
        return Move(
            gs.board[Move.getOppositeI(int.parse(spliced[0]))]
                [Move.getOppositej(int.parse(spliced[1]))],
            gs.board[Move.getOppositeI(int.parse(spliced[2]))]
                [Move.getOppositej(int.parse(spliced[3]))],
            gs.playersTurn);
      } else {
        return Move(
          gs.board[int.parse(spliced[0])][int.parse(spliced[1])],
          gs.board[int.parse(spliced[2])][int.parse(spliced[3])],
          gs.playersTurn,
        );
      }
    }
    chrt char = getCharFromInitials(spliced[0]);
    Tile initialTile = gs.myGraveyard.firstWhere((t) => t.char == char);
    Tile finalTile = gs.board[int.parse(spliced[2])][int.parse(spliced[3])];
    return Move(initialTile, finalTile, gs.playersTurn);
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

Move makeLocalDecision(GameState gameState) {
  List<Tile> myPieces = getMyPieces(gameState);
  Tile myPiece = getRandomObject(myPieces);
  List<Move> myMoves = getMoves(myPiece, gameState);
  if (myMoves.isNotEmpty) {
    return getRandomObject(myMoves);
  }
  return makeLocalDecision(gameState);
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
