import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:minichess/app/data/enums.dart';
import 'package:minichess/app/modules/match/controllers/match_making_controller.dart';

import '../../../utils/utils.dart';
import '../controllers/match_controller.dart';

class GameoverView extends GetView<MatchController> {
  GameoverView({Key? key}) : super(key: key);
  // var matchMakingController = Get.find<MatchController>();

  Color getTextColor() {
    return controller.winner == player.white ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: controller.winner == player.white
          ? const Color.fromARGB(225, 255, 255, 255)
          : const Color.fromARGB(225, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              'Winner: ${controller.winner == player.white ? 'White' : 'Black'}',
              style: TextStyle(
                  color: getTextColor(),
                  fontSize: 48,
                  fontWeight: FontWeight.bold)),
          SizedBox(
              width: 250,
              height: 250,
              child: getCharAsset(chrt.queen, controller.winner, false)),
          if (controller.gamemode == gameMode.solo || controller.gamemode == gameMode.vs)
            Text(
              'W   B\n${controller.wScore} - ${controller.bScore}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: getTextColor(),
                  fontSize: 42,
                  fontWeight: FontWeight.bold),
            ),
          if (controller.gamemode != gameMode.online)
            SizedBox(
              height: 40,
              width: 150,
              child: ElevatedButton(
                onPressed: controller.restartGame,
                child: const Text(
                  'Restart',
                ),
              ),
            ),
          if (controller.gamemode == gameMode.online)
            Obx(() {
              return SizedBox(
                  height: 100,
                  width: 170,
                  child: Center(
                    child: Text(
                        'Your Score:\n'
                        '${controller.myLocalScore.value}'
                        '${controller.isWinner.value! ? '+' : '-'}'
                        '${controller.scoreChange.value}',
                        style: TextStyle(
                            color: getTextColor(),
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                  ));
            }),
          Text('GameId: ${DateTime.now().millisecondsSinceEpoch.toString()}',
              style: TextStyle(color: getTextColor())),
        ],
      ),
    );
  }
}
