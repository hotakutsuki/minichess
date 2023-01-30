import 'dart:async';

import 'package:get/get.dart';
import 'package:minichess/app/modules/match/controllers/match_controller.dart';

import '../../../data/enums.dart';

class ClockController extends GetxController {
  late MatchController matchController;
  Rx<player?> localPlayer = Rxn<player>();

  static const gameMinutes = 2;
  Timer? countdownTimer;
  var myDuration = Duration(minutes: gameMinutes).obs;
  // Rx<Duration> myDuration = Rx<Duration>(const Duration(minutes: gameMinutes));
  // Duration myDuration = Duration(minutes: gameMinutes);

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
      myDuration.value = const Duration(minutes: gameMinutes);
    }
  }

  setCountDown() {
    const reduceMillisecondsBy = 100;
    final mSeconds = myDuration.value.inMilliseconds - reduceMillisecondsBy;
    if (mSeconds < 0) {
      matchController.gameOver(localPlayer.value == player.white ? player.black : player.white);
      countdownTimer!.cancel();
    } else {
      myDuration.value = Duration(milliseconds: mSeconds);
    }
  }

  @override
  void onInit() {
    super.onInit();
    matchController = Get.find<MatchController>();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
