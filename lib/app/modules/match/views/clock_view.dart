import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import '../../../data/enums.dart';
import '../controllers/clock_controller.dart';

class ClockView extends GetView {
  ClockView(this.myPlayer, {Key? key}) : super(key: key);
  final myPlayer;
  late final ClockController clockController =
      Get.put(ClockController(), tag: myPlayer.toString());

  Color getColor(){
    if(myPlayer == player.white){
      return whitePlayerColor;
    }
    return blackPlayerColor;
  }

  @override
  Widget build(BuildContext context) {
    clockController.localPlayer = myPlayer;
    return Column(
      children: [
        if (false)
          Obx(() {
            return Text(
              '${clockController.minutes}:${clockController.seconds}:${clockController.milliseconds}',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: clockController.myDuration.inSeconds > 20
                      ? Colors.white70
                      : Colors.redAccent,
                  fontSize: 24),
            );
          }),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: graveyardHeight-7,
              height: graveyardHeight-7,
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
                border: Border.all(color: getColor(), width: 2),
              ),
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(getColor(), BlendMode.modulate),
              child: Lottie.asset(
                'assets/animations/moon.json',
                width: graveyardHeight,
                height: graveyardHeight,
                controller: clockController.animController,

              ),
            ),
          ],
        ),
      ],
    );
  }
}
