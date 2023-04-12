import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:minichess/app/modules/match/controllers/ai_controller.dart';
import 'package:minichess/app/modules/match/controllers/clock_controller.dart';

import '../../../data/enums.dart';
import '../../../data/matchDom.dart';
import '../../../data/usefullData.dart';
import '../../../data/userDom.dart';
import '../../../routes/app_pages.dart';
import '../../../services/database.dart';
import '../../../utils/gameObjects/GameState.dart';
import '../../../utils/gameObjects/move.dart';
import '../../../utils/gameObjects/tile.dart';
import '../../../utils/utils.dart';
import '../../home/controllers/home_controller.dart';
import 'match_making_controller.dart';

class MatchController extends GetxController {
  Rxn<GameState> gs = Rxn<GameState>();
  DatabaseController dbController = Get.find<DatabaseController>();
  final homeController = Get.find<HomeController>();
  final gameMode gamemode = Get.arguments ?? gameMode.vs;

  int wScore = 0, bScore = 0;
  final selectedTile = Rxn<Tile>();

  player playersTurn = player.white;
  player winner = player.none;
  Rx<bool> isGameOver = false.obs;
  List<String> boardHistory = [];
  List<Move> whiteHistory = [];
  List<Move> blackHistory = [];

  Timer? countdownTimer;
  var myDuration = const Duration(seconds: 100);
  final searchingSeconds = '100'.obs;
  final serchingTimeLimit = getRandomIntBetween(20, 40);

  late ClockController whiteClockState;
  late ClockController blackClockState;
  late ClockController searchingClockState;
  late AiController aiController;
  List<dynamic> remoteTiles = [];
  List<dynamic> localTiles = [];
  late Rx<bool> searching = false.obs;

  Rxn<User> hostUser = Rxn<User>(null);
  Rxn<User> invitedUser = Rxn<User>(null);

  final gameId = ''.obs;
  final isHost = Rx<bool>(true);
  Rxn<bool> isWinner = Rxn<bool>();
  Rxn<int> myLocalScore = Rxn<int>();
  Rxn<int> scoreChange = Rxn<int>();

  bool isFake = false;

  Function eq = const ListEquality().equals;

  Future<bool> startOnlineMatch() async {
    List<MatchDom> openMatches = await dbController.getOpenMatches();
    if (openMatches.isEmpty) {
      print('creating new match');
      isHost.value = true;
      return await dbController.addMatch();
      // if (result) {
      //   homeController.setMode(gameMode.online);
      // }
    } else {
      gameId.value = openMatches[0].id;
      print('joining to match ${gameId.value}');
      isHost.value = false;
      return await dbController.joinToAMatch();
      // if (result) {
      //   homeController.setMode(gameMode.online);
      // }
    }
  }

  void updateScore(bool imWinner, myScore, oponentScore) {
    //TODO:Enhance this
    print('isWinner: $imWinner');
    print('myScore: $myScore');
    print('oponentScore: $oponentScore');
    bool imBetter = myScore > oponentScore;
    double ratio = 1;
    if (imWinner && imBetter) {
      ratio = oponentScore / myScore; // lit/big = little
    }
    if (!imWinner && !imBetter) {
      ratio = myScore / oponentScore; // lit/big = little
    }
    if (imWinner && !imBetter) {
      ratio = oponentScore / myScore; // big/lit = big
    }
    if (!imWinner && imBetter) {
      ratio = myScore / oponentScore; // big/lit = big
    }
    isWinner.value = imWinner;
    myLocalScore.value = myScore;
    scoreChange.value = (100 * ratio).round();
    int newScore =
        imWinner ? myScore + scoreChange.value : myScore - scoreChange.value;
    print('radio: $ratio, change: ${scoreChange.value}');
    dbController.updateScore(newScore);
  }

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
    searching.value = event[MatchDom.STATE] == gameState.open.name;
    remoteTiles = event[MatchDom.TILES];
    if (remoteTiles.length > localTiles.length) {
      localTiles = List.from(remoteTiles);
      if (remoteTiles.isNotEmpty) {
        Tile tile = Tile.fromString(remoteTiles.last);
        if (isFromGraveyard(tile)) {
          play(gs.value!.myGraveyard.firstWhere((t) => t.char == tile.char));
        } else {
          play(gs.value!.board[tile.j!][tile.i!]);
        }
      }
    }
    if (event[MatchDom.INVITEDPLAYERID] != null) {
      if (event[MatchDom.INVITEDPLAYERID] == 'fake') {
        print('playing fake match');
        invitedUser.value ??= createFakeUser();
        isFake = true;
      } else {
        stopTimer();
        isFake = false;
        invitedUser.value ??=
            await dbController.getUserByUserId(event[MatchDom.INVITEDPLAYERID]);
      }
    }
    hostUser.value ??=
        await dbController.getUserByUserId(event[MatchDom.HOSTPLAYERID]);
  }

  User createFakeUser() {
    int rndImage = getRandomIntBetween(3400, 4300);
    int rndScore = getRandomIntBetween(3000, 8000);
    var imageUrl = 'https://thispersondoesnotexist.xyz/img/$rndImage.jpg';
    int rndName = getRandomInt(UsefullData.mixedNames.length - 1);
    var name = UsefullData.mixedNames[rndName];
    return User('fake', name, 'unknown', imageUrl, rndScore, 'unknown',
        'unknown', 'city');
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
      return (isHost.value! && playersTurn == player.white) ||
          (!isHost.value! && playersTurn == player.black);
    }
    return true;
  }

  play(Tile tile) async {
    if (selectedTile.value == null) {
      if (tile.char != chrt.empty && tile.owner == possession.mine) {
        tile.isSelected = true;
        selectedTile.value = tile;
        print('selectedTile: $selectedTile');
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
              (gamemode == gameMode.solo && playersTurn == player.black) ||
              (gamemode == gameMode.online && playersTurn == player.black && isFake))) {
        await playAsPc();
      }
    }
  }

  onTapTile(Tile tile) async {
    print('tapping tile: $tile');
    if (isValidPlay(tile)) {
      if (gamemode == gameMode.online) {
        localTiles.add(tile.toString());
        print('localTiles $localTiles');
        dbController.updatePlayedHistory();
      }
      play(tile);
    }
  }

  playAsPc() async {
    print('playing as pc');
    Move move = await aiController.getPlay(gs.value!, gamemode);
    print('generated move: $move');
    if (gamemode == gameMode.solo || gamemode == gameMode.online) {
      await Future.delayed(Duration(milliseconds: getRandomIntBetween(400, 1000)));
    }
    play(move.initialTile);
    if (gamemode == gameMode.solo || gamemode == gameMode.online) {
      await Future.delayed(Duration(milliseconds: getRandomIntBetween(400, 1000)));
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
      bool imWinner = (p == player.black) ^ isHost.value!;
      int myScore =
          isHost.value! ? hostUser.value!.score : invitedUser.value!.score;
      int oponentScore =
          isHost.value! ? invitedUser.value!.score : hostUser.value!.score;
      updateScore(imWinner, myScore, oponentScore);
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
    playersTurn = player.white;

    resetTimers();
    initBoardState();
  }

  void closeTheGame() {
    restartGame();
    if (gamemode == gameMode.online) {
      dbController.closeMatch();
    }
    Get.offAndToNamed(Routes.HOME);
  }

  initBoardState() {
    gs.value = GameState.named(
      board: createNewBoard(),
      enemyGraveyard: <Tile>[],
      myGraveyard: <Tile>[],
    );
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  stopTimer() {
    if (countdownTimer != null) {
      countdownTimer!.cancel();
    }
  }

  setCountDown() {
    const reduceSecondsBy = 1;
    final mSeconds = myDuration.inSeconds - reduceSecondsBy;
    if (mSeconds < serchingTimeLimit) {
      countdownTimer!.cancel();
      startFakeOnlineGame();
    } else {
      myDuration = Duration(seconds: mSeconds);
      searchingSeconds.value = strDigits(myDuration.inSeconds.remainder(100));
    }
  }

  String strDigits(int n) => n.toString().padLeft(2, '0');

  startFakeOnlineGame() {
    dbController.setMatchAsFake();
  }

  @override
  void onInit() {
    super.onInit();
    initBoardState();
    // Get.lazyPut<MatchMakingController>(
    //       () => MatchMakingController(),
    // );
    searching.value = gamemode == gameMode.online;
    if (searching.value) {
      startTimer();
    }
  }

  @override
  void onReady() async {
    print('match controller ready');
    whiteClockState = Get.find<ClockController>(tag: player.white.toString());
    blackClockState = Get.find<ClockController>(tag: player.black.toString());
    aiController = Get.put(AiController());
    if (gamemode == gameMode.online) {
      bool result = await startOnlineMatch();
      if (result) {
        dbController.startListenersOfMatch();
      } else {
        closeTheGame();
      }
    }
    if (!isGameOver.value && gamemode == gameMode.training) {
      playAsPc();
    }
    super.onReady();
  }

  @override
  void onClose() {
    print('closing match controller');
    super.onClose();
  }
}
