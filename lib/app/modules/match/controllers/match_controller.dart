import 'package:get/get.dart';
import 'package:minichess/app/modules/match/controllers/ai_controller.dart';
import 'package:minichess/app/modules/match/controllers/clock_controller.dart';

import '../../../data/enums.dart';
import '../../../utils/gameObjects/GameState.dart';
import '../../../utils/gameObjects/move.dart';
import '../../../utils/gameObjects/tile.dart';
import '../../../utils/utils.dart';
import 'match_making_controller.dart';

class MatchController extends GetxController {
  Rxn<GameState> gs = Rxn<GameState>();
  final gameMode gamemode = Get.arguments ?? gameMode.vs;

  int wScore = 0, bScore = 0;
  final selectedTile = Rxn<Tile>();

  player playersTurn = player.white;
  player winner = player.none;
  Rx<bool> isGameOver = false.obs;
  List<String> boardHistory = [];
  List<Move> whiteHistory = [];
  List<Move> blackHistory = [];

  late ClockController whiteClockState;
  late ClockController blackClockState;
  late AiController aiController;

  highlightAvailableOptions() {
    for (var row in gs.value!.board) {
      for (Tile v in row) {
        v.isOption = selectedTile.value != null &&
            checkIfValidMove(Move(selectedTile.value!, v), gs.value!, true);
      }
    }
    gs.update((val) => val);
  }

  void setTimersAndPlayers() {
    if (playersTurn == player.white) {
      whiteClockState.stopTimer();
      blackClockState.startTimer();
    } else {
      whiteClockState.startTimer();
      blackClockState.stopTimer();
    }
  }

  void resetTimers() {
    blackClockState.stopTimer();
    whiteClockState.stopTimer();
    whiteClockState.resetTimer();
    blackClockState.resetTimer();
  }

  void restarSelected(Tile newTile) {
    selectedTile.value!.isSelected = false;
    selectedTile.value = null;
  }

  void recordHistory(Tile tile) {
    boardHistory.add(gs.toString());
    if (playersTurn == player.white) {
      whiteHistory.add(Move(selectedTile.value!, tile));
    } else {
      blackHistory.add(Move(selectedTile.value!, tile));
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
    if (gamemode == gameMode.solo) {
      return playersTurn == player.white;
    }
    return true;
  }

  play(Tile tile) async {
    if (selectedTile.value == null) {
      if(tile.char != chrt.empty && tile.owner == possession.mine){
        tile.isSelected = true;
        selectedTile.value = tile;
        highlightAvailableOptions();
      }
    } else {
      if (checkIfValidMove(Move(selectedTile.value!, tile), gs.value!, true)) {
        recordHistory(tile);
        setTimersAndPlayers();
        Move move = Move(selectedTile.value!, tile);
        if (checkIfWin(move)) {
          gameOver(playersTurn);
        }
        gs.update((val) => val!.changeGameState(move));
        gs.value!.rotate();
        togglePlayersTurn();
      }
      restarSelected(tile);
      highlightAvailableOptions();
      if (!isGameOver.value &&
          (gamemode == gameMode.training ||
              (gamemode == gameMode.solo &&
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
    Move move = await aiController.getPlay(gs.value!, gamemode);
    print('generated move: $move');
    if (gamemode == gameMode.solo) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    play(move.initialTile);
    if (gamemode == gameMode.solo) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    play(move.finalTile);
  }

  void gameOver(player p) async {
    winner = p;
    isGameOver.value = true;
    blackClockState.stopTimer();
    whiteClockState.stopTimer();
    if (p == player.white) {
      wScore++;
    } else {
      bScore++;
    }

    if (await isConnected()) {
      print('saving match...');
      aiController.storeMovemntHistory(boardHistory, whiteHistory, blackHistory, winner);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    if (gamemode == gameMode.training) {
      restartGame();
    }
  }

  void restartGame() {
    selectedTile.value = null;
    winner = player.none;
    isGameOver.value = false;
    blackHistory.clear();
    whiteHistory.clear();
    boardHistory.clear();

    resetTimers();
    onInit();
  }

  @override
  void onInit() {
    print('initing match match controller');
    super.onInit();
    gs.value = GameState.named(
      board: createNewBoard(),
      enemyGraveyard: <Tile>[],
      myGraveyard: <Tile>[],
    );
  }

  @override
  void onReady() {
    whiteClockState = Get.find<ClockController>(tag: player.white.toString());
    blackClockState = Get.find<ClockController>(tag: player.black.toString());
    aiController = Get.put(AiController());
    if (!isGameOver.value && gamemode == gameMode.training) {
      playAsPc();
    }
    // if (!isGameOver.value && gamemode == gameMode.online){
    //   final matchMakingController = Get.find<MatchMakingController>();
    //   matchMakingController.startNewMatch();
    // }
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
