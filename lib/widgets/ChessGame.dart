import 'package:flutter/cupertino.dart';
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
  late GameState gs;

  int wScore = 0, bScore = 0;
  Tile? selectedTile;

  late player playersTurn;
  player winner = player.none;
  bool isGameOver = false;
  List<String> boardHistory = [];
  List<Move> whiteHistory = [];
  List<Move> blackHistory = [];

  final GlobalKey<ClockState> whiteClockState = GlobalKey<ClockState>();
  final GlobalKey<ClockState> blackClockState = GlobalKey<ClockState>();

  @override
  initState() {
    gs = GameState.named(
      board: createNewBoard(),
      enemyGraveyard: <Tile>[],
      myGraveyard: <Tile>[],
    );
    playersTurn = player.white;
    if (!isGameOver && widget.gamemode == gameMode.training) {
      playAsPc();
    }
  }

  highlightAvailableOptions() {
    for (var row in gs.board) {
      for (var v in row) {
        v.isOption = selectedTile != null &&
            checkIfValidMove(Move(selectedTile!, v), gs, true);
      }
    }
  }

  void setTimersAndPlayers() {
    if (playersTurn == player.white) {
      whiteClockState.currentState?.stopTimer();
      blackClockState.currentState?.startTimer();
    } else {
      whiteClockState.currentState?.startTimer();
      blackClockState.currentState?.stopTimer();
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
    boardHistory.add(gs.toString());
    if (playersTurn == player.white) {
      whiteHistory.add(Move(selectedTile!, tile));
    } else {
      blackHistory.add(Move(selectedTile!, tile));
    }
  }

  void togglePlayersTurn() {
    if (playersTurn == player.white) {
      playersTurn = player.black;
    } else if (playersTurn == player.black) {
      playersTurn = player.white;
    }
  }

  bool isValidPlay(Tile tile) {
    if (widget.gamemode == gameMode.solo) {
      return playersTurn == player.white;
    }
    return true;
  }

  play(Tile tile) async {
    if (selectedTile == null) {
      if(tile.char != chrt.empty && tile.owner == possession.mine){
        setState(() {
          selectedTile = tile;
          tile.isSelected = true;
          highlightAvailableOptions();
        });
      }
    } else {
      setState(() {
        if (checkIfValidMove(Move(selectedTile!, tile), gs, true)) {
          recordHistory(tile);
          setTimersAndPlayers();
          Move move = Move(selectedTile!, tile);
          if (checkIfWin(move)) {
            gameOver(playersTurn);
          }
          gs.changeGameState(move);
          gs.rotate();
          togglePlayersTurn();
        }
        restarSelected(tile);
        highlightAvailableOptions();
      });
      if (!isGameOver &&
          (widget.gamemode == gameMode.training ||
              (widget.gamemode == gameMode.solo &&
                  playersTurn == player.black))) {
        await playAsPc();
      }
    }
  }

  onTapTile(Tile tile) async {
    if (isValidPlay(tile)){
      play(tile);
    }
  }

  playAsPc() async {
    Move move = await getPlay(gs, widget.gamemode);
    print('generated move: $move');
    if (widget.gamemode == gameMode.solo) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    play(move.initialTile);
    if (widget.gamemode == gameMode.solo) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    play(move.finalTile);
  }

  void gameOver(player p) async {
    setState(() {
      isGameOver = true;
      winner = p;
      blackClockState.currentState?.stopTimer();
      whiteClockState.currentState?.stopTimer();
      if (p == player.white) {
        wScore++;
      } else {
        bScore++;
      }
    });
    if (await isConnected()) {
      print('saving match...');
      storeMovemntHistory(boardHistory, whiteHistory, blackHistory, winner);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    if (widget.gamemode == gameMode.training) {
      restartGame();
    }
  }

  void restartGame() {
    setState(() {
      selectedTile = null;
      winner = player.none;
      isGameOver = false;
      blackHistory.clear();
      whiteHistory.clear();
      boardHistory.clear();
    });
    resetTimers();
    initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotatedBox(
                  quarterTurns: 2,
                  child: Clock(
                      key: blackClockState,
                      player: player.black,
                      gameOver: gameOver)),
              Graveyard(
                  graveyard: playersTurn == player.white
                      ? gs.enemyGraveyard
                      : gs.myGraveyard,
                  p: player.black,
                  onTapTile: onTapTile),
              RotatedBox(
                  quarterTurns: playersTurn == player.white ? 0 : 2,
                  child: ChessBoard(
                      matrix: gs.board,
                      onTapTile: onTapTile,
                      playersTurn: playersTurn)),
              Graveyard(
                  graveyard: playersTurn == player.white
                      ? gs.myGraveyard
                      : gs.enemyGraveyard,
                  p: player.white,
                  onTapTile: onTapTile),
              Clock(
                  key: whiteClockState,
                  player: player.white,
                  gameOver: gameOver),
              // SizedBox(
              //   height: 40,
              //   width: 150,
              //   child: ElevatedButton(
              //     onPressed: restartGame,
              //     child: const Text(
              //       'Restart',
              //     ),
              //   ),
              // ),
              // Text('${playersTurn ?? 'none'}'),
            ],
          ),
        ),
        !isGameOver
            ? const SizedBox()
            : GameOverScreen(
                winner, restartGame, wScore, bScore, widget.gamemode),
        Positioned(
          top: 8,
          right: 8,
          child: FloatingActionButton(
            heroTag: 'close',
            backgroundColor: Colors.white,
            mini: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, color: Colors.black87),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: FloatingActionButton(
            heroTag: 'restart',
            backgroundColor: Colors.white,
            mini: true,
            onPressed: restartGame,
            child: const Icon(CupertinoIcons.refresh, color: Colors.black87),
          ),
        )
      ]),
    );
  }
}
