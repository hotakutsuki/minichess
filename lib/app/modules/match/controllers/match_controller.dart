import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:inti_the_inka_chess_game/app/modules/match/controllers/tile_controller.dart';

import '../../../data/enums.dart';
import '../../../data/matchDom.dart';
import '../../../data/sandbox_config.dart';
import '../../../data/usefullData.dart';
import '../../../data/userDom.dart';
import '../../../engine/rule_modifier.dart';
import '../../../routes/app_pages.dart';
import '../../../services/database.dart';
import '../../../utils/gameObjects/gameState.dart';
import '../../../utils/gameObjects/move.dart';
import '../../../utils/gameObjects/tile.dart';
import '../../../utils/juice.dart';
import '../../../utils/utils.dart';
import '../../home/controllers/home_controller.dart';
import '../../language/controllers/language_controller.dart';
import '../widgets/graveyard_flight.dart';
import 'GraveyardController.dart';
import 'ai_controller.dart';
import 'clock_controller.dart';

class MatchController extends GetxController with WidgetsBindingObserver {
  Rxn<GameState> gs = Rxn<GameState>();
  DatabaseController dbController = Get.find<DatabaseController>();
  LanguageController l = Get.find<LanguageController>();

  final homeController = Get.find<HomeController>();

  // The match route argument is normally a [gameMode]. A [SandboxConfig] instead
  // launches a solo match with rule modifiers active (debug tool).
  late final gameMode gamemode =
      Get.arguments is SandboxConfig ? gameMode.solo : (Get.arguments ?? gameMode.vs);
  late final List<RuleModifier> _modifiers = Get.arguments is SandboxConfig
      ? (Get.arguments as SandboxConfig).modifiers
      : const [];

  Rx<int> wScore = 0.obs, bScore = 0.obs;
  final selectedTile = Rxn<Tile>();

  // --- Graveyard-flight plumbing (measured, magic-number-free animations) ---
  // A stable GlobalKey per board grid slot "i,j" and per graveyard [player], so
  // [flyToGraveyard] can measure real on-screen rects. Board slots are reused
  // across rotations (one tile per slot per frame), so identity stays unique.
  final Map<String, GlobalKey> _tileKeys = {};
  final Map<player, GlobalKey> _graveKeys = {};
  // Board slots whose piece is mid-flight to a graveyard: rendered empty so the
  // overlay copy isn't duplicated by the still-present board piece.
  final Set<String> _hiddenTiles = {};

  GlobalKey tileKey(int? i, int? j) =>
      _tileKeys.putIfAbsent('$i,$j', () => GlobalKey());
  GlobalKey graveKey(player p) => _graveKeys.putIfAbsent(p, () => GlobalKey());
  bool isTileHidden(int? i, int? j) => _hiddenTiles.contains('$i,$j');

  late player playersTurn = player.white;
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
  var pausa = false.obs;

  Function eq = const ListEquality().equals;

  var isLoading = true.obs;
  var isAnimating = false.obs;
  var aiControllerInitialized = false.obs;

  var moveAudioPLayer = AudioPlayer();

  Timer? reFetchTimer;
  int reFetchTime = 5;

  Future<bool> startOnlineMatch() async {
    List<MatchDom> openMatches = await dbController.getOpenMatches();
    var ans;
    if (openMatches.isEmpty) {
      print('creating new match');
      isHost.value = true;
      ans = await dbController.addMatch();
    } else {
      gameId.value = openMatches[0].id;
      print('joining to match ${gameId.value}');
      isHost.value = false;
      ans = await dbController.joinToAMatch();
    }
    // Start timeout to read the game document every 5 seconds
    reFetchTimer =
        Timer.periodic(Duration(seconds: reFetchTime), (Timer t) async {
      if ((isHost.value && playersTurn == player.black) ||
          (!isHost.value && playersTurn == player.white)) {
        var event = await dbController.readDocState();
        whenMatchStateChange(event);
      }
    });
    return ans;
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
      int startPosition = localTiles.length;
      localTiles = List.from(remoteTiles);
      if (remoteTiles.isNotEmpty) {
        // Tile tile = Tile.fromString(remoteTiles.last);
        // var playedTimeStamp = int.parse(remoteTiles.last.split(' ')[5]);
        // if (isFromGraveyard(tile)) {
        //   play(gs.value!.myGraveyard.firstWhere((t) => t.char == tile.char));
        //   // blackClockState.setCountRemaining(remoteTiles)
        //   // whiteClockState.setCountRemaining(remoteTiles)
        // } else {
        //   play(gs.value!.board[tile.j!][tile.i!]);
        // }
        for (int i = startPosition; i < remoteTiles.length; i++) {
          Tile tile = Tile.fromString(remoteTiles[i]);
          if (isFromGraveyard(tile)) {
            await play(
                gs.value!.myGraveyard.firstWhere((t) => t.char == tile.char));
          } else {
            await play(gs.value!.board[tile.j!][tile.i!]);
          }
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
        'unknown', 'city', 'pass');
  }

  void setTimersAndPlayers() {
    blackClockState.setCountRemaining(localTiles);
    blackClockState.updateTexts();
    whiteClockState.setCountRemaining(localTiles);
    whiteClockState.updateTexts();
    if (playersTurn == player.white) {
      whiteClockState.stopTimer();
      blackClockState.startTimer();
    } else {
      blackClockState.stopTimer();
      whiteClockState.startTimer();
    }
  }

  void resetTimers() {
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
      return (isHost.value && playersTurn == player.white) ||
          (!isHost.value && playersTurn == player.black);
    }
    return true;
  }

  play(Tile tile) async {
    if (pausa.value) {
      return;
    }
    if (selectedTile.value == null) {
      if (tile.char != chrt.empty && tile.owner == possession.mine) {
        tile.isSelected = true;
        selectedTile.value = tile;
        Juice.select();
        // print('selectedTile: $selectedTile');
        highlightAvailableOptions();
      }
    } else {
      if (checkIfValidMove(Move(selectedTile.value!, tile), gs.value!, true)) {
        isAnimating.value = true;
        recordHistory(tile);
        setTimersAndPlayers();
        Move move = Move(selectedTile.value!, tile);
        final bool isCapture = tile.char != chrt.empty;
        if (homeController.withSound.value) {
          moveAudioPLayer.play(AssetSource('sounds/wind.mp3'), volume: 0.5);
        }
        if (!isCapture) Juice.move();
        await animateTiles(move);
        if (checkIfWin(move)) {
          gameOver(playersTurn);
        }
        gs.update((val) => val!.changeGameState(move));
        gs.value!.rotate();
        togglePlayersTurn();
        await _runTurnTick(); // animate + apply per-turn effects for the new mover
      }
      restarSelected(tile);
      highlightAvailableOptions();
      isAnimating.value = false;
      if (!isGameOver.value &&
          (gamemode == gameMode.training ||
              (gamemode == gameMode.solo && playersTurn == player.black) ||
              (gamemode == gameMode.online &&
                  playersTurn == player.black &&
                  isFake))) {
        await playAsPc();
      }
    }
  }

  animateTiles(Move move) async {
    if (gs.value!.board[move.finalTile.j!][move.finalTile.i!].char !=
        chrt.empty) {
      // "Invertir posesión": the captured piece returns to its owner, so it
      // lands in the OPPONENT's graveyard — animate that one's reveal, not the
      // captor's, otherwise the wrong panel opens, and fly the piece to the far
      // graveyard instead of the captor's.
      final bool returnsToOwner = gs.value!.modifiers.any((m) =>
          m.appliesTo(possession.mine, gs.value!) &&
          m.returnsCapturedToOwner());
      final player receiver = returnsToOwner
          ? (playersTurn == player.white ? player.black : player.white)
          : playersTurn;
      GraveyardController gyController =
          Get.find<GraveyardController>(tag: receiver.name);
      int slot = gyController.getGraveyard(receiver).length;
      Juice.capture();
      // The piece the mover landed on.
      _flyCapturedToGrave(move.finalTile.toString(), move.finalTile.i!,
          move.finalTile.j!, slot, far: returnsToOwner);
      // "Embestida": the extra pieces the strike clears fly to the same
      // graveyard, stacking on the following slots (matching the order the
      // engine buries them in [GameState.applyExtraCaptures]).
      for (final c in _areaCaptureTiles(move)) {
        slot++;
        _flyCapturedToGrave(gs.value!.board[c[1]][c[0]].toString(), c[0], c[1],
            slot, far: returnsToOwner);
      }
      gyController.animateGraveyard();
    }
    if (isFromGraveyard(move.initialTile)) {
      GraveyardController gyController =
          Get.find<GraveyardController>(tag: playersTurn.name);
      int idx = gyController
          .getGraveyard(playersTurn)
          .indexWhere((element) => element.isSelected);
      TileController tileController =
          Get.find<TileController>(tag: move.initialTile.toString());
      await tileController.animateTile(
          null, null, move.finalTile.i, move.finalTile.j, idx);
    }
    if (!isFromGraveyard(move.initialTile)) {
      TileController tileController =
          Get.find<TileController>(tag: move.initialTile.toString());
      await tileController.animateTile(move.initialTile.i!, move.initialTile.j!,
          move.finalTile.i, move.finalTile.j);
    }
  }

  // The board tiles an "Embestida" (area capture) will also clear as `[i, j]`
  // pairs, in the exact order the engine buries them
  // ([GameState.applyExtraCaptures]): each active modifier's [extraCaptures],
  // keeping only on-board enemy non-king tiles, de-duplicated (the engine skips
  // an already-cleared square). Used to fly them to the graveyard.
  List<List<int>> _areaCaptureTiles(Move move) {
    final g = gs.value!;
    final tiles = <List<int>>[];
    final seen = <String>{};
    for (final m in g.modifiers) {
      if (!m.appliesTo(possession.mine, g)) continue;
      for (final c in m.extraCaptures(move, g)) {
        final i = c[0], j = c[1];
        if (j < 0 || j >= g.board.length || i < 0 || i >= g.board[j].length) {
          continue;
        }
        final t = g.board[j][i];
        if (t.owner != possession.enemy ||
            t.char == chrt.empty ||
            t.char == chrt.king) {
          continue;
        }
        if (seen.add('$i,$j')) tiles.add([i, j]);
      }
    }
    return tiles;
  }

  // Flash a captured (enemy) tile gold and fly it to the graveyard with the same
  // slide+shrink as a normal capture. [far] sends it to the OPPONENT's graveyard
  // (used by "invertir posesión"): the captured piece is drawn 180°-rotated, so
  // the near graveyard is reached with a downward `-1 - j`; the far one needs an
  // upward target instead.
  void _flyCapturedToGrave(String tag, int i, int j, int slot,
      {required bool far}) {
    if (!Get.isRegistered<TileController>(tag: tag)) return;
    final tc = Get.find<TileController>(tag: tag);
    tc.flash();
    final int ij = far ? (gs.value!.board.length - j) : (-1 - j);
    tc.animateTile(i, ij, null, null, slot);
  }

  onTapTile(Tile tile) async {
    if (isAnimating.value) {
      return;
    }
    if (isValidPlay(tile)) {
      if (gamemode == gameMode.online) {
        localTiles.add(tile.toStingWithTimeStamp());
        dbController.updatePlayedHistory();
      }
      play(tile);
    }
  }

  /// Select a piece because the player started dragging it.
  void selectForDrag(Tile tile) {
    if (isAnimating.value || pausa.value) return;
    if (!isValidPlay(tile)) return;
    if (tile.char == chrt.empty || tile.owner != possession.mine) return;
    if (selectedTile.value == tile) return;
    if (selectedTile.value != null) {
      selectedTile.value!.isSelected = false;
    }
    tile.isSelected = true;
    selectedTile.value = tile;
    Juice.select();
    highlightAvailableOptions();
  }

  /// Finish a drag: [from] was the dragged piece, [to] is where it was dropped.
  /// Reuses the tap path, so an illegal or same-square drop just deselects.
  void onDragDrop(Tile from, Tile to) {
    if (isAnimating.value) return;
    if (selectedTile.value != from) {
      selectForDrag(from);
    }
    if (selectedTile.value == null) return;
    onTapTile(to);
  }

  /// The dragged piece was dropped nowhere valid — clear the selection.
  void cancelSelection() {
    if (selectedTile.value != null) {
      selectedTile.value!.isSelected = false;
      selectedTile.value = null;
      highlightAvailableOptions();
    }
  }

  playAsPc() async {
    print('playing as pc');
    Move move = await aiController.getPlay(gs.value!, gamemode);
    print('generated move: $move');
    if (gamemode == gameMode.solo || gamemode == gameMode.online) {
      await Future.delayed(
          Duration(milliseconds: getRandomIntBetween(400, 1000)));
    }
    // if (playersTurn == player.black){
    play(move.initialTile);
    // }
    if (gamemode == gameMode.solo || gamemode == gameMode.online) {
      await Future.delayed(
          Duration(milliseconds: getRandomIntBetween(400, 1000)));
    }
    if (gamemode == gameMode.training) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (aiController.diff.value == difficult.easy) {
        aiController.diff.value = difficult.hard;
      } else if (aiController.diff.value == difficult.hard) {
        aiController.diff.value = difficult.easy;
      }
    }
    // if (playersTurn == player.black){
    play(move.finalTile);
    // }
  }

  void gameOver(player p) async {
    winner = p;
    isGameOver.value = true;
    Juice.gameOver();
    blackClockState.stopTimer();
    whiteClockState.stopTimer();
    if (p == player.white) {
      wScore.value++;
    } else {
      bScore.value++;
    }

    if (gamemode == gameMode.online) {
      bool imWinner = (p == player.black) ^ isHost.value;
      int myScore =
          isHost.value ? hostUser.value!.score : invitedUser.value!.score;
      int oponentScore =
          isHost.value ? invitedUser.value!.score : hostUser.value!.score;
      updateScore(imWinner, myScore, oponentScore);
    }

    if (reFetchTimer != null) {
      reFetchTimer!.cancel();
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

  void restartGame([bool force = false]) async {
    print('trying to restart');
    if (isAnimating.value && !force) {
      print('restart omited');
      return;
    }
    print('restarting...');
    isLoading.value = true;

    selectedTile.value = null;
    winner = player.none;
    isGameOver.value = false;
    blackHistory.clear();
    whiteHistory.clear();
    boardHistory.clear();
    playersTurn = player.white;
    resetTimers();
    initBoardState();

    aiController.diff.value = homeController.diff.value;

    await Future.delayed(const Duration(milliseconds: 1000));
    isLoading.value = false;

    if (!isGameOver.value && gamemode == gameMode.training) {
      await playAsPc();
    }
  }

  void closeTheGame() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    restartGame(true);
    if (gamemode == gameMode.online) {
      dbController.closeMatch();
    }
    Get.offAndToNamed(Routes.HOME);
    // setMode() left the menu curtain down underneath the match. Let the home
    // screen mount with that curtain still covering it, then lift it so the menu
    // is revealed with the same slide-up animation used when entering a match
    // (setting it false immediately skips the animation and the curtain just
    // vanishes). The lift itself uses the same 500ms easeOutExpo as every other
    // curtain; this pause just lets it rest a beat before rising, like on entry.
    await Future.delayed(const Duration(milliseconds: 500));
    homeController.isLoading.value = false;
  }

  initBoardState() {
    gs.value = GameState.named(
      board: createNewBoard(),
      enemyGraveyard: <Tile>[],
      // enemyGraveyard: <Tile>[Tile(chrt.pawn, possession.enemy, null, null)],
      myGraveyard: <Tile>[],
      modifiers: _modifiers,
    );
  }

  // Runs the active modifiers' per-turn effects (spawn/wither/wind) at the start
  // of the side-to-move's turn, then repaints the board. No-op without modifiers,
  // so vanilla matches are untouched. Any piece the effect moves (e.g. a Viento
  // gust) is first slid with the normal move animation, then committed — so it
  // never just teleports.
  Future<void> _runTurnTick() async {
    if (gs.value!.modifiers.isEmpty) return;
    final reveals = await _animateTickMoves(gs.value!.planTurnStart());
    gs.value!.applyTurnStart(); // commit while any death curtain is up
    gs.update((val) => val);
    await Future.wait(reveals); // let the graveyard reveals finish
    _clearHiddenTiles();
  }

  // Animates every piece a per-turn effect is about to move, then returns so the
  // state change can be committed — so nothing ever teleports. A board slide
  // reuses the ordinary-move translate; a [TickMove.toGrave] death flies to the
  // owner's graveyard with the capture animation. Wind pieces are enemy-owned,
  // whose tile is drawn inside a 180° RotatedBox, so a slide is fed reversed
  // (destination→source) to cancel that rotation.
  Future<List<Future>> _animateTickMoves(List<TickMove> moves) async {
    if (moves.isEmpty) return const [];
    // Let the just-rotated board finish building so each source tile is mounted.
    await WidgetsBinding.instance.endOfFrame;
    final awaitNow = <Future>[]; // slides + death landings (before commit)
    final reveals = <Future>[]; // death curtain retracts (after commit)
    for (final mv in moves) {
      final t = gs.value!.board[mv.fromJ][mv.fromI];
      if (mv.toGrave) {
        // Marchitar (and any future in-place death): fly to the graveyard.
        final landed = Completer<void>();
        reveals.add(_flyBoardPieceToGrave(mv.fromI, mv.fromJ, t.char, t.owner,
            onArrive: () {
          if (!landed.isCompleted) landed.complete();
        }));
        awaitNow.add(landed.future);
        continue;
      }
      final tag = t.toString();
      if (!Get.isRegistered<TileController>(tag: tag)) continue;
      final tc = Get.find<TileController>(tag: tag);
      final bool enemy = t.owner == possession.enemy;
      awaitNow.add(enemy
          ? tc.animateTile(mv.toI, mv.toJ, mv.fromI, mv.fromJ)
          : tc.animateTile(mv.fromI, mv.fromJ, mv.toI, mv.toJ));
    }
    await Future.wait(awaitNow);
    return reveals;
  }

  // Flies a board piece at (i,j) to its owner's graveyard: hides the board copy
  // (so the overlay isn't duplicated), launches the overlay flight, and returns
  // the reveal future. [onArrive] fires when the piece is hidden behind the
  // risen curtain — the moment to commit the state so the graveyard add stays
  // covered until the reveal.
  Future<void> _flyBoardPieceToGrave(
      int i, int j, chrt char, possession owner,
      {required VoidCallback onArrive}) async {
    // A piece's own graveyard is the mover's (playersTurn) side; an enemy piece
    // goes to the opponent's.
    final player receiver = owner == possession.mine
        ? playersTurn
        : (playersTurn == player.white ? player.black : player.white);
    final ctx = Get.context;
    final GlobalKey? fromKey = _tileKeys['$i,$j'];
    final GlobalKey? toKey = _graveKeys[receiver];
    if (ctx == null || fromKey == null || toKey == null) {
      onArrive();
      return;
    }
    _hiddenTiles.add('$i,$j');
    gs.update((val) => val);
    final chrt buried = gs.value!.graveChar(char, owner);
    // The graveyard strip flips black (top) pieces 180°; the whole zone flips
    // again for an online guest — so a piece flips iff exactly one applies.
    final bool flip = (receiver == player.black) ^
        (gamemode == gameMode.online && !isHost.value);
    await flyToGraveyard(
      ctx,
      fromKey: fromKey,
      toKey: toKey,
      piece: getCharAsset(buried, receiver, false),
      rotate: flip,
      onArrive: onArrive,
      duration:
          Duration(milliseconds: gamemode == gameMode.training ? 100 : 800),
    );
  }

  void _clearHiddenTiles() {
    if (_hiddenTiles.isEmpty) return;
    _hiddenTiles.clear();
    gs.update((val) => val);
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

  String getRandomGameOverScreenText() {
    if (winner == player.white) {
      String key = 'mtp${getRandomIntBetween(1, 27)}';
      return l.g(key);
    }
    String key = 'mtn${getRandomIntBetween(1, 16)}';
    return l.g(key);
  }

  @override
  void onInit() {
    super.onInit();
    initBoardState();
    searching.value = gamemode == gameMode.online;
    if (searching.value) {
      startTimer();
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() async {
    if (homeController.withSound.value) {
      homeController.stopTitleSong();
    }

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

    homeController.playBattleSong();

    await Future.delayed(const Duration(milliseconds: 1000));
    isLoading.value = false;

    aiControllerInitialized.value = true;
    aiController.diff.value = homeController.diff.value;

    if (!isGameOver.value && gamemode == gameMode.training) {
      await playAsPc();
    }

    super.onReady();
  }

  @override
  void onClose() {
    homeController.playTitleSong();
    Get.back(closeOverlays: true);
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
