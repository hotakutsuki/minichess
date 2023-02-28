import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:minichess/app/modules/match/controllers/ai_controller.dart';
import 'package:minichess/app/modules/match/controllers/clock_controller.dart';

import '../../../data/enums.dart';
import '../../../data/matchDom.dart';
import '../../../data/userDom.dart';
import '../../../routes/app_pages.dart';
import '../../../services/database.dart';
import '../../../utils/gameObjects/GameState.dart';
import '../../../utils/gameObjects/move.dart';
import '../../../utils/gameObjects/tile.dart';
import '../../../utils/utils.dart';
import 'match_making_controller.dart';

class MatchController extends GetxController {
  Rxn<GameState> gs = Rxn<GameState>();
  DatabaseController databaseController = Get.find<DatabaseController>();
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
  late MatchMakingController matchMakingController;
  late List<dynamic> remoteTiles = [];
  DatabaseController dbController = Get.find<DatabaseController>();

  Rxn<User> hostUser = Rxn<User>(null);
  Rxn<User> invitedUser = Rxn<User>(null);

  highlightAvailableOptions() {
    for (var row in gs.value!.board) {
      for (Tile v in row) {
        v.isOption = selectedTile.value != null &&
            checkIfValidMove(Move(selectedTile.value!, v), gs.value!, true);
      }
    }
    gs.update((val) => val);
  }

  void whenMatchStateChange(DocumentSnapshot event) async {
    print('event: $event');
    remoteTiles = event[MatchDom.TILES];
    matchMakingController.searching.value =
        event[MatchDom.STATE] == gameState.open.name;

    invitedUser.value ??= await databaseController
        .getUserByUserId(event[MatchDom.INVITEDPLAYERID]);
    hostUser.value ??=
        await databaseController.getUserByUserId(event[MatchDom.HOSTPLAYERID]);

    if (remoteTiles.isNotEmpty) {
      Tile tile = Tile.fromString(remoteTiles.last);
      if (matchMakingController.isHost.value!) {
        if (playersTurn == player.black) {
          play(tile);
        }
      } else {
        if (playersTurn == player.white) {
          play(tile);
        }
      }
    }
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
    if (gamemode == gameMode.online) {
      return (matchMakingController.isHost.value! &&
              playersTurn == player.white) ||
          (!matchMakingController.isHost.value! && playersTurn == player.black);
    }
    return true;
  }

  play(Tile tile) async {
    if (selectedTile.value == null) {
      if (tile.char != chrt.empty && tile.owner == possession.mine) {
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
              (gamemode == gameMode.solo && playersTurn == player.black))) {
        await playAsPc();
      }
    }
  }

  onTapTile(Tile tile) async {
    if (isValidPlay(tile)) {
      if (gamemode == gameMode.online) {
        dbController.addPlayedTile(tile);
      }
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

    if (gamemode == gameMode.online) {
      bool imWinner = (p == player.black) ^ matchMakingController.isHost.value!;
      int myScore = matchMakingController.isHost.value!
          ? hostUser.value!.score
          : invitedUser.value!.score;
      int oponentScore = matchMakingController.isHost.value!
          ? invitedUser.value!.score
          : hostUser.value!.score;
      matchMakingController.updateScore(imWinner, myScore, oponentScore);
    }

    if (await isConnected()) {
      print('saving match...');
      aiController.storeMovemntHistory(
          boardHistory, whiteHistory, blackHistory, winner);
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

  void closeTheGame() {
    Get.offAndToNamed(Routes.HOME);
    dbController.closeMatch();
  }

  @override
  void onInit() {
    super.onInit();
    gs.value = GameState.named(
      board: createNewBoard(),
      enemyGraveyard: <Tile>[],
      myGraveyard: <Tile>[],
    );
  }

  @override
  void onReady() {
    print('match controller ready');
    whiteClockState = Get.find<ClockController>(tag: player.white.toString());
    blackClockState = Get.find<ClockController>(tag: player.black.toString());
    aiController = Get.put(AiController());
    if (!isGameOver.value && gamemode == gameMode.training) {
      playAsPc();
    }
    if (gamemode == gameMode.online) {
      matchMakingController = Get.find<MatchMakingController>();
      print('starting online game with $matchMakingController');
      DatabaseController dbController = Get.find<DatabaseController>();
      dbController.startListenersOfMatch();
    }
    // if (!isGameOver.value && gamemode == gameMode.online){
    //   final matchMakingController = Get.find<MatchMakingController>();
    //   matchMakingController.startNewMatch();
    // }
    super.onReady();
  }

  @override
  void onClose() {
    print('closing match controller');
    super.onClose();
  }
}
