import 'package:flutter/material.dart';
import 'package:minichess/ai/Ai.dart';
import 'package:minichess/doms/GameState.dart';
import 'package:minichess/utils/Enums.dart';
import 'package:minichess/widgets/ChessBoard.dart';
import '../doms/Move.dart';
import '../doms/Tile.dart';
import '../utils/utils.dart';
import 'Clock.dart';
import 'Graveyard.dart';

class ChessGame extends StatefulWidget {
  const ChessGame({Key? key}) : super(key: key);

  @override
  State<ChessGame> createState() => _MyChessGamePage();
}

class _MyChessGamePage extends State<ChessGame> {
  bool isVsPc = true;

  List<List<Tile>> board = [];
  List<Tile> graveyardW = [];
  List<Tile> graveyardB = [];
  Tile? selectedTile;
  player lastPlayedPlayer = player.black;
  player winner = player.none;
  bool isGameOver = false;
  List<String> boardHistory = [];
  List<Move> whiteHistory = [];
  List<Move> blackHistory = [];

  final GlobalKey<ClockState> whiteClockState = GlobalKey<ClockState>();
  final GlobalKey<ClockState> blackClockState = GlobalKey<ClockState>();

  initState() {
    board = createNewBoard();
    if (isVsPc) {
      lastPlayedPlayer = player.black;
    }
    if (!isGameOver && isVsPc) {
      playAsPc();
    }
  }

  bool isWhitesTurn() {
    return lastPlayedPlayer == player.black || lastPlayedPlayer == player.none;
  }

  bool isBlacksTurn() {
    return lastPlayedPlayer == player.white;
  }

  player getPlayersTurn() {
    return isBlacksTurn() ? player.black : player.white;
  }

  GameState getCurrentGameState() {
    return GameState(
      board,
      isBlacksTurn() ? graveyardB : graveyardW,
      isWhitesTurn() ? graveyardB : graveyardW,
      getPlayersTurn(),
    );
  }

  isDIfferentTile(Tile newTile) {
    return selectedTile!.i != newTile.i || selectedTile!.j != newTile.j;
  }

  void sendPieceToGrave(Tile newTile) {
    if (board[newTile.i!][newTile.j!].char != chrt.empty) {
      if (newTile.owner == player.white) {
        graveyardB.add(Tile.fromParameters(newTile.char, player.black));
      } else {
        graveyardW.add(Tile.fromParameters(newTile.char, player.white));
      }
    }
  }

  void transformPawn(Tile newTile) {
    if (selectedTile!.char == chrt.pawn) {
      if (selectedTile!.owner == player.white && newTile.i == 0) {
        newTile.char = chrt.knight;
      }
      if (selectedTile!.owner == player.black && newTile.i == 3) {
        newTile.char = chrt.knight;
      }
    }
  }

  void checkIfWin(Tile newTile) {
    if (newTile.char == chrt.king) {
      gameOver(selectedTile!.owner);
    }
  }

  void rewritePosition(Tile newTile) {
    checkIfWin(newTile);
    newTile.char = selectedTile!.char;
    newTile.owner = selectedTile!.owner;
    transformPawn(newTile);
    if (isFromGraveyard(selectedTile!)) {
      graveyardB.removeWhere((element) => element.isSelected);
      graveyardW.removeWhere((element) => element.isSelected);
    } else {
      selectedTile!.char = chrt.empty;
      selectedTile!.owner = player.none;
    }
  }

  highlightAvailableOptions() {
    for (var row in board) {
      for (var v in row) {
        v.isOption = checkIfValidPosition(v, selectedTile);
      }
    }
  }

  void setTimersAndPlayers() {
    if (selectedTile!.owner == player.white) {
      whiteClockState.currentState?.stopTimer();
      blackClockState.currentState?.startTimer();
      lastPlayedPlayer = player.white;
    } else {
      whiteClockState.currentState?.startTimer();
      blackClockState.currentState?.stopTimer();
      lastPlayedPlayer = player.black;
    }
  }

  void resetTimers() {
    blackClockState.currentState?.stopTimer();
    whiteClockState.currentState?.stopTimer();
    whiteClockState.currentState?.resetTimer();
    blackClockState.currentState?.resetTimer();
  }

  void restarSelected(Tile newTile) {
    selectedTile!.isSelected = false;
    selectedTile = null;
  }

  void recordHistory(Tile tile) {
    boardHistory.add(getCurrentGameState().toString());
    if (selectedTile!.owner == player.white) {
      whiteHistory.add(Move(selectedTile!, tile, getPlayersTurn()));
    } else {
      blackHistory.add(Move(selectedTile!, tile, getPlayersTurn()));
    }
  }

  onTapTile(Tile? tile) async {
    print(tile);
    if (tile == null) {
      print('ERROR 1');
      return;
    }
    if (selectedTile == null) {
      print('decidiendo...');
      if (tile.char != chrt.empty && lastPlayedPlayer != tile.owner) {
        setState(() {
          selectedTile = tile;
          tile.isSelected = true;
          highlightAvailableOptions();
        });
      }
    } else {
      print('jugando $selectedTile');
      setState(() {
        if (checkIfValidPosition(tile, selectedTile)) {
          recordHistory(tile);
          setTimersAndPlayers();
          sendPieceToGrave(tile);
          rewritePosition(tile);
        }
        restarSelected(tile);
        highlightAvailableOptions();
      });
      if (!isGameOver && isVsPc) {
        await playAsPc();
      }
    }
  }

  playAsPc() async {
    Move move = await getPlay(getCurrentGameState());
    print('playing $move');
    // await Future.delayed(const Duration(milliseconds: 1000));
    onTapTile(move.initialTile);
    // await Future.delayed(const Duration(milliseconds: 5000));
    onTapTile(move.finalTile);
  }

  void gameOver(player p) async {
    setState(() {
      isGameOver = true;
      winner = p;
      blackClockState.currentState?.stopTimer();
      whiteClockState.currentState?.stopTimer();
    });
    storeMovemntHistory(boardHistory, whiteHistory, blackHistory, winner);
    // await Future.delayed(const Duration(milliseconds: 500));
    restartGame();
    initState();
  }

  void restartGame() {
    setState(() {
      board = createNewBoard();
      selectedTile = null;
      graveyardB = [];
      graveyardW = [];
      lastPlayedPlayer = player.none;
      winner = player.none;
      isGameOver = false;
      blackHistory.clear();
      whiteHistory.clear();
      boardHistory.clear();
    });
    resetTimers();
  }

  Widget restartButton() {
    return SizedBox(
      height: 40,
      width: 150,
      child: ElevatedButton(
        onPressed: restartGame,
        child: const Text(
          'Restart',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Divider(
                height: 24,
                color: Colors.transparent,
              ),
              RotatedBox(
                  quarterTurns: 2,
                  child: Clock(
                      key: blackClockState,
                      player: player.black,
                      gameOver: gameOver)),
              Graveyard(
                  graveyard: graveyardB, p: player.black, onTapTile: onTapTile),
              ChessBoard(matrix: board, onTapTile: onTapTile),
              Graveyard(
                  graveyard: graveyardW, p: player.white, onTapTile: onTapTile),
              Clock(
                  key: whiteClockState,
                  player: player.white,
                  gameOver: gameOver),
              restartButton(),
            ],
          ),
        ),
        !isGameOver
            ? const SizedBox()
            : Container(
                width: double.infinity,
                height: double.infinity,
                color: winner == player.white
                    ? const Color.fromARGB(225, 255, 255, 255)
                    : const Color.fromARGB(225, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Winner: ${winner == player.white ? 'White' : 'Black'}',
                        style: TextStyle(
                            color: winner == player.white
                                ? Colors.black
                                : Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                        width: 250,
                        height: 250,
                        child: getImage(chrt.queen, winner)),
                    restartButton(),
                  ],
                ),
              )
      ]),
    );
  }
}
