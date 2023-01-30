import 'dart:async';

import 'package:get/get.dart';
import 'package:minichess/app/modules/match/controllers/match_controller.dart';

import '../../../data/enums.dart';

class ClockController extends GetxController {
  late MatchController matchController;
  late player localPlayer;

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
    }
  }

  setCountDown() {
    const reduceMillisecondsBy = 100;
    final mSeconds = myDuration.inMilliseconds - reduceMillisecondsBy;
    if (mSeconds < 0) {
      matchController.gameOver(localPlayer == player.white ? player.black : player.white);
      countdownTimer!.cancel();
    } else {
      myDuration = Duration(milliseconds: mSeconds);
      minutes.value = strDigits(myDuration.inMinutes.remainder(60));
      seconds.value = strDigits(myDuration.inSeconds.remainder(60));
      milliseconds.value = strDigitsSeconds((myDuration.inMilliseconds.remainder(1000)/10).floor());
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
