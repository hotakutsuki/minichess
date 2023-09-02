import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums.dart';
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
  String strDigitsSeconds(int n) => (n/10).toString().padLeft(1, '0');

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(milliseconds: 100), (_) => setCountDown());
  }

  stopTimer() {
    if (countdownTimer != null) {
      countdownTimer!.cancel();
    }
  }

  resetTimer() {
    if (countdownTimer != null){
      stopTimer();
      myDuration = const Duration(minutes: gameMinutes);
      // countdownTimer = null;
      updateTexts();
    }
  }

  setCountDown() {
    const reduceMillisecondsBy = 100;
    final mSeconds = myDuration.inMilliseconds - reduceMillisecondsBy;
    print('counting down $mSeconds');
    if (mSeconds < 0 && countdownTimer!=null) {
      matchController.gameOver(localPlayer == player.white ? player.black : player.white);
      countdownTimer!.cancel();
    } else {
      myDuration = Duration(milliseconds: mSeconds);
      updateTexts();
    }
  }

  updateTexts(){
    double value = 0.99 //final state of animation
        - ((myDuration.inSeconds / (gameMinutes * 60))
                / 2); // starts at the middle
    animController.animateTo(value);
    minutes.value = strDigits(myDuration.inMinutes.remainder(60));
    seconds.value = strDigits(myDuration.inSeconds.remainder(60));
    milliseconds.value = strDigitsSeconds((myDuration.inMilliseconds.remainder(1000)/10).floor());
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
