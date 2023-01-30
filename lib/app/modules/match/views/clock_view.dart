import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:minichess/app/modules/match/controllers/clock_controller.dart';

class ClockView extends GetView {
  ClockView(this.player, {Key? key}) : super(key: key);
  final player;
  late final ClockController clockController = Get.put(ClockController(), tag: player.toString());
  String strDigits(int n) => n.toString().padLeft(2, '0');
  late final minutes = strDigits(clockController.myDuration.inMinutes.remainder(60));
  late final seconds = strDigits(clockController.myDuration.inSeconds.remainder(60));
  late final milliseconds = strDigits((clockController.myDuration.inMilliseconds.remainder(1000)/100).floor());

  @override
  Widget build(BuildContext context) {
    clockController.localPlayer.value = player;
    return Text(
      '$minutes:$seconds:$milliseconds',
      style: TextStyle(
          fontWeight: FontWeight.w600,
          color: clockController.myDuration.inSeconds > 20 ? Colors.black87 : Colors.redAccent,
          fontSize: 24),
    );
  }
}
