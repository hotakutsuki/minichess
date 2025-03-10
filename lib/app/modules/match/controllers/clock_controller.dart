import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inti_the_inka_chess_game/app/utils/gameObjects/GameState.dart';

import '../../../data/enums.dart';
import '../../../utils/gameObjects/move.dart';
import '../../../utils/gameObjects/tile.dart';
import '../../../utils/utils.dart';
import 'match_controller.dart';

class ClockController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late MatchController matchController;
  late player localPlayer;
  late final AnimationController animController;

  static const gameMinutes = 2;
  Timer? countdownTimer;
  var myDuration = const Duration(minutes: gameMinutes);

  final minutes = '0$gameMinutes'.obs;
  final seconds = '00'.obs;
  final milliseconds = '0'.obs;

  String strDigits(int n) => n.toString().padLeft(2, '0');

  String strDigitsSeconds(int n) => (n / 10).toString().padLeft(1, '0');

  void startTimer() {
    countdownTimer = Timer.periodic(
        const Duration(milliseconds: 100), (_) => setCountDown());
  }

  stopTimer() {
    if (countdownTimer != null) {
      countdownTimer!.cancel();
    }
  }

  resetTimer() {
    if (countdownTimer != null) {
      stopTimer();
      myDuration = const Duration(minutes: gameMinutes);
      updateTexts();
    }
  }

  setCountDown() {
    const reduceMillisecondsBy = 100;
    final mSeconds = myDuration.inMilliseconds - reduceMillisecondsBy;
    if (mSeconds < 0 && countdownTimer != null) {
      matchController
          .gameOver(localPlayer == player.white ? player.black : player.white);
      countdownTimer!.cancel();
    } else {
      myDuration = Duration(milliseconds: mSeconds);
      updateTexts();
    }
  }

  void setCountRemaining(List<dynamic> localTiles) {
    var whiteElpased = 0;
    var blackElapsed = 0;
    List<int> timeStamps  = [];
    var selectedTile = null;
    var playersTurn = player.white;
    var gs = GameState.named(
      board: createNewBoard(),
      enemyGraveyard: List<Tile>.from([]),
      myGraveyard: List<Tile>.from([]),
    );

    localTiles.forEach((localTile) {
      Tile tile = Tile.fromString(localTile as String);
      if (selectedTile == null) {
        if (tile.char != chrt.empty && tile.owner == possession.mine) {
          tile.isSelected = true;
          selectedTile = tile;
        }
      } else {
        if (checkIfValidMove(Move(selectedTile, tile), gs, true)) {
          playersTurn =
              playersTurn == player.white ? player.black : player.white;
          timeStamps.add(int.parse(localTile.split(" ")[5]));
        }
        selectedTile = null;
      }
    });

    for (var i = 0; i < timeStamps.length; i++) {
      if (i > 0) {
        if (i % 2 == 0) {
          whiteElpased +=  timeStamps[i] - timeStamps[i - 1];
        } else {
          blackElapsed += timeStamps[i] - timeStamps[i - 1];
        }
      }
    }

    if (timeStamps.length != 0) {
      if (localPlayer == player.white) {
        whiteElpased += DateTime.now().millisecondsSinceEpoch - timeStamps.last;
        myDuration = Duration(milliseconds: Duration(minutes: gameMinutes).inMilliseconds - Duration(milliseconds:whiteElpased).inMilliseconds);
      } else {
        blackElapsed += DateTime.now().millisecondsSinceEpoch - timeStamps.last;
        myDuration = Duration(milliseconds: Duration(minutes: gameMinutes).inMilliseconds - Duration(milliseconds:blackElapsed).inMilliseconds);
      }
    }
  }

  updateTexts() {
    double value = 0.99 //final state of animation
        -
        ((myDuration.inSeconds / (gameMinutes * 60)) /
            2); // starts at the middle
    animController.animateTo(value);
    minutes.value = strDigits(myDuration.inMinutes.remainder(60));
    seconds.value = strDigits(myDuration.inSeconds.remainder(60));
    milliseconds.value = strDigitsSeconds(
        (myDuration.inMilliseconds.remainder(1000) / 10).floor());
  }

  @override
  void onInit() {
    super.onInit();
    matchController = Get.find<MatchController>();
    animController = AnimationController(vsync: this);
    animController.duration = const Duration(seconds: 0);
    animController.animateTo(0.5);
    animController.stop();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    animController.dispose();
    super.onClose();
  }
}
