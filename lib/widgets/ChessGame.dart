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

  List<List<Tile>> board = [[]];
  List<Tile> graveyardW = [];
  List<Tile> graveyardB = [];
  Tile? selectedTile;
  player lastPlayedPlayer = player.none;
  player winner = player.none;
  bool isGameOver = false;


  final GlobalKey<ClockState> whiteClockState = GlobalKey<ClockState>();
  final GlobalKey<ClockState> blackClockState = GlobalKey<ClockState>();

  initState() {
    board = createNewBoard();
    if (isVsPc) {
      lastPlayedPlayer = player.black;
    }
  }

  isDIfferentTile(Tile newTile) {
    return selectedTile!.i != newTile.i || selectedTile!.j != newTile.j;
  }

  void sendPieceToGrave(Tile newTile) {
    if (board[newTile.i!][newTile.j!].char != character.empty) {
      if (newTile.owner == player.white) {
        graveyardB.add(Tile.fromParameters(newTile.char, player.black));
      } else {
        graveyardW.add(Tile.fromParameters(newTile.char, player.white));
      }
    }
  }

  void transformPawn(Tile newTile) {
    if (selectedTile!.char == character.pawn) {
      if (selectedTile!.owner == player.white && newTile.i == 0) {
        newTile.char = character.knight;
      }
      if (selectedTile!.owner == player.black && newTile.i == 3) {
        newTile.char = character.knight;
      }
    }
  }

  void checkIfWin(Tile newTile) {
    if (newTile.char == character.king) {
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
      selectedTile!.char = character.empty;
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

  onTapTile(Tile tile) {
    if (selectedTile == null) {
      if (tile.char != character.empty && lastPlayedPlayer != tile.owner) {
        setState(() {
          selectedTile = tile;
          tile.isSelected = true;
          highlightAvailableOptions();
        });
      }
    } else {
      setState(() {
        if (checkIfValidPosition(tile, selectedTile)) {
          setTimersAndPlayers();
          sendPieceToGrave(tile);
          rewritePosition(tile);
        }
        restarSelected(tile);
        highlightAvailableOptions();
      });
      if (!isGameOver && isVsPc && lastPlayedPlayer == player.white) {
        playAsPc();
      }
    }
  }

  void playAsPc() async {
    Move move = getPlay(GameState(
      board,
      lastPlayedPlayer == player.white ? graveyardB : graveyardW,
      lastPlayedPlayer == player.white ? graveyardW : graveyardB,
      lastPlayedPlayer == player.white ? player.black : player.white,
    ));
    await Future.delayed(const Duration(milliseconds: 500));
    onTapTile(move.initialTile);
    await Future.delayed(const Duration(milliseconds: 500));
    onTapTile(move.finalTile);
  }

  void gameOver(player p) {
    setState(() {
      isGameOver = true;
      winner = p;
      blackClockState.currentState?.stopTimer();
      whiteClockState.currentState?.stopTimer();
    });
  }

  Widget restartButton() {
    return SizedBox(
      height: 40,
      width: 150,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            board = createNewBoard();
            selectedTile = null;
            graveyardB = [];
            graveyardW = [];
            lastPlayedPlayer = player.none;
            winner = player.none;
            isGameOver = false;
          });
          resetTimers();
        },
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
                        child: getImage(character.queen, winner)),
                    restartButton(),
                  ],
                ),
              )
      ]),
    );
  }
}
