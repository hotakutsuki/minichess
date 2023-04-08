import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:minichess/app/modules/match/controllers/clock_controller.dart';

class ClockView extends GetView {
  ClockView(this.player, {Key? key}) : super(key: key);
  final player;
  late final ClockController clockController = Get.put(
      ClockController(), tag: player.toString());

  @override
  Widget build(BuildContext context) {
    clockController.localPlayer = player;
    return Obx(() {
      return Text(
        '${clockController.minutes}:${clockController.seconds}:${clockController
            .milliseconds}',
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: clockController.myDuration.inSeconds > 20
                ? Colors.black87
                : Colors.redAccent,
            fontSize: 24),
      );
    });
  }
}
