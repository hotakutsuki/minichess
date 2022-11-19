import 'package:flutter/material.dart';
import 'package:minichess/ai/Ai.dart';
import 'package:minichess/doms/GameState.dart';
import 'package:minichess/screens/GameOverScreen.dart';
import 'package:minichess/utils/Enums.dart';
import 'package:minichess/widgets/ChessBoard.dart';
import '../doms/Move.dart';
import '../doms/Tile.dart';
import '../utils/utils.dart';
import 'Clock.dart';
import 'Graveyard.dart';

class ChessGame extends StatefulWidget {
  const ChessGame({Key? key, required this.gamemode}) : super(key: key);

  final gameMode gamemode;

  @override
  State<ChessGame> createState() => _MyChessGamePage();
}

class _MyChessGamePage extends State<ChessGame> {
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

  @override
  initState() {
    switch (widget.gamemode) {
      case gameMode.solo:
        lastPlayedPlayer = player.none;
        break;
      case gameMode.training:
      case gameMode.vs:
        lastPlayedPlayer = player.black;
    }

    board = createNewBoard();

    if (!isGameOver && widget.gamemode == gameMode.training) {
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
      widget.gamemode,
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
    if (tile == null) {
      throw Exception("Error On Tap tile");
    }
    if (selectedTile == null) {
      if (tile.char != chrt.empty && lastPlayedPlayer != tile.owner) {
        setState(() {
          selectedTile = tile;
          tile.isSelected = true;
          highlightAvailableOptions();
        });
      }
    } else {
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
      if (!isGameOver &&
          (widget.gamemode == gameMode.training ||
              (widget.gamemode == gameMode.solo &&
                  getPlayersTurn() == player.black))) {
        await playAsPc();
      }
    }
  }

  playAsPc() async {
    Move move = await getPlay(getCurrentGameState());
    // getCurrentGameState().printState();
    print('generated move: $move');
    if (widget.gamemode == gameMode.solo) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    onTapTile(move.initialTile);
    if (widget.gamemode == gameMode.solo) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    onTapTile(move.finalTile);
  }

  void gameOver(player p) async {
    setState(() {
      isGameOver = true;
      winner = p;
      blackClockState.currentState?.stopTimer();
      whiteClockState.currentState?.stopTimer();
    });
    if (await isConnected()) {
      print('saving match...');
      storeMovemntHistory(boardHistory, whiteHistory, blackHistory, winner);
    }
    if (widget.gamemode == gameMode.training) {
      restartGame();
      initState();
    }
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
              SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton(
                  onPressed: restartGame,
                  child: const Text(
                    'Restart',
                  ),
                ),
              ),
            ],
          ),
        ),
        !isGameOver ? const SizedBox() : GameOverScreen(winner, restartGame)
      ]),
    );
  }
}
