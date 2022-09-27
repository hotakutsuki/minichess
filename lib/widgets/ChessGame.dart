import 'package:flutter/material.dart';
import 'package:minichess/utils/Enums.dart';
import 'package:minichess/widgets/ChessBoard.dart';
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
  List<List<Tile>> matrix = [[]];
  List<Tile> graveyardW = [];
  List<Tile> graveyardB = [];
  var selectedTile;
  player lastPlayedPlayer = player.none;
  player winner = player.none;
  bool isGameOver = false;

  final GlobalKey<ClockState> whiteClockState = GlobalKey<ClockState>();
  final GlobalKey<ClockState> blackClockState = GlobalKey<ClockState>();

  initState() {
    matrix = createNewBoard();
  }

  isDIfferentTile(newTile) {
    return selectedTile.i != newTile.i || selectedTile.j != newTile.j;
  }

  void sendPieceToGrave(Tile newTile) {
    if (matrix[newTile.i!][newTile.j!].char != character.empty) {
      if (newTile.owner == player.white) {
        graveyardB.add(Tile.fromParameters(newTile.char, player.black));
      } else {
        graveyardW.add(Tile.fromParameters(newTile.char, player.white));
      }
    }
  }

  void transformPawn(Tile newTile) {
    if (selectedTile.char == character.pawn) {
      if (selectedTile.owner == player.white && newTile.i == 0) {
        newTile.char = character.knight;
      }
      if (selectedTile.owner == player.black && newTile.i == 3) {
        newTile.char = character.knight;
      }
    }
  }

  void checkIfWin(Tile newTile){
    print(newTile.char);
    if (newTile.char == character.king){
      gameOver(selectedTile.owner);
    }
  }

  void rewritePosition(Tile newTile) {
    checkIfWin(newTile);
    newTile.char = selectedTile.char;
    newTile.owner = selectedTile.owner;
    transformPawn(newTile);
    if (isFromGraveyard()) {
      graveyardB.removeWhere((element) => element.isSelected);
      graveyardW.removeWhere((element) => element.isSelected);
    } else {
      selectedTile.char = character.empty;
      selectedTile.owner = player.none;
    }
  }

  bool isFromGraveyard() {
    return selectedTile.i == null;
  }

  bool checkIfValidPosition(Tile tile) {
    if (selectedTile == null) {
      return false;
    } else if (isFromGraveyard()) {
      return tile.char == character.empty;
    } else {
      if (selectedTile.owner == tile.owner) {
        return false;
      } else {
        switch (selectedTile.char) {
          case character.pawn:
            if (selectedTile.owner == player.white) {
              return selectedTile.i! - 1 == tile.i && selectedTile.j == tile.j;
            } else {
              return selectedTile.i! + 1 == tile.i && selectedTile.j == tile.j;
            }
          case character.king:
            return (selectedTile.i + 1 == tile.i &&
                selectedTile.j + 1 == tile.j) ||
                (selectedTile.i + 1 == tile.i && selectedTile.j == tile.j) ||
                (selectedTile.i + 1 == tile.i &&
                    selectedTile.j - 1 == tile.j) ||
                (selectedTile.i == tile.i && selectedTile.j + 1 == tile.j) ||
                (selectedTile.i == tile.i && selectedTile.j - 1 == tile.j) ||
                (selectedTile.i - 1 == tile.i &&
                    selectedTile.j + 1 == tile.j) ||
                (selectedTile.i - 1 == tile.i && selectedTile.j == tile.j) ||
                (selectedTile.i - 1 == tile.i && selectedTile.j - 1 == tile.j);
          case character.bishop:
            return (selectedTile.i + 1 == tile.i &&
                selectedTile.j + 1 == tile.j) ||
                (selectedTile.i + 1 == tile.i &&
                    selectedTile.j - 1 == tile.j) ||
                (selectedTile.i - 1 == tile.i &&
                    selectedTile.j + 1 == tile.j) ||
                (selectedTile.i - 1 == tile.i && selectedTile.j - 1 == tile.j);
          case character.rock:
            return (selectedTile.i + 1 == tile.i && selectedTile.j == tile.j) ||
                (selectedTile.i == tile.i && selectedTile.j + 1 == tile.j) ||
                (selectedTile.i == tile.i && selectedTile.j - 1 == tile.j) ||
                (selectedTile.i - 1 == tile.i && selectedTile.j == tile.j);
          case character.knight:
            if (selectedTile.owner == player.white) {
              return (selectedTile.i + 1 == tile.i &&
                  selectedTile.j == tile.j) ||
                  (selectedTile.i == tile.i && selectedTile.j + 1 == tile.j) ||
                  (selectedTile.i == tile.i && selectedTile.j - 1 == tile.j) ||
                  (selectedTile.i - 1 == tile.i && selectedTile.j == tile.j) ||
                  (selectedTile.i - 1 == tile.i &&
                      selectedTile.j + 1 == tile.j) ||
                  (selectedTile.i - 1 == tile.i &&
                      selectedTile.j - 1 == tile.j);
            } else {
              return (selectedTile.i + 1 == tile.i &&
                  selectedTile.j == tile.j) ||
                  (selectedTile.i == tile.i && selectedTile.j + 1 == tile.j) ||
                  (selectedTile.i == tile.i && selectedTile.j - 1 == tile.j) ||
                  (selectedTile.i - 1 == tile.i && selectedTile.j == tile.j) ||
                  (selectedTile.i + 1 == tile.i &&
                      selectedTile.j + 1 == tile.j) ||
                  (selectedTile.i + 1 == tile.i &&
                      selectedTile.j - 1 == tile.j);
            }
        }
      }
    }
    return false;
  }

  highlightAvailableOptions() {
    for (var row in matrix) {
      for (var v in row) {
        v.isOption = checkIfValidPosition(v);
      }
    }
  }

  void setTimersAndPlayers() {
    if (selectedTile.owner == player.white) {
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
    selectedTile.isSelected = false;
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
        if (checkIfValidPosition(tile)) {
          setTimersAndPlayers();
          sendPieceToGrave(tile);
          rewritePosition(tile);
        }
        restarSelected(tile);
        highlightAvailableOptions();
      });
    }
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
            matrix = createNewBoard();
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
              const Divider(height: 24),
              RotatedBox(quarterTurns: 2,
                  child: Clock(key: blackClockState,
                      player: player.black,
                      gameOver: gameOver)),
              Graveyard(
                  graveyard: graveyardB, p: player.black, onTapTile: onTapTile),
              ChessBoard(matrix: matrix, onTapTile: onTapTile),
              Graveyard(
                  graveyard: graveyardW, p: player.white, onTapTile: onTapTile),
              Clock(key: whiteClockState,
                  player: player.white,
                  gameOver: gameOver),
              restartButton(),
            ],
          ),
        ),
        !isGameOver ? const SizedBox() : Container(
          width: double.infinity,
          height: double.infinity,
          color: winner == player.white ? const Color.fromARGB(
              225, 255, 255, 255) : const Color.fromARGB(225, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Winner: ${winner == player.white ? 'White' : 'Black'}',
                  style: TextStyle(
                      color: winner == player.white ? Colors.black : Colors.white,
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
