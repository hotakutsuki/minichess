import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/utils.dart';
import '../../language/controllers/language_controller.dart';
import '../controllers/match_controller.dart';
import '../../../data/enums.dart';

class GameoverView extends GetView<MatchController> {
  GameoverView({Key? key}) : super(key: key);

  LanguageController l = Get.find<LanguageController>();

  Color getTextColor() {
    return controller.winner == player.white ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color:
          controller.winner == player.white ? Colors.white70 : Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              '${l.g('Winner')} ${controller.winner == player.white ? l.g('Sun') : l.g('Moon')}',
              style: TextStyle(
                  color: getTextColor(),
                  fontSize: 48,
                  fontWeight: FontWeight.bold)),
          SizedBox(
              width: 250,
              height: 250,
              child: getCharAsset(chrt.queen, controller.winner, true)),
          if (controller.gamemode == gameMode.solo ||
              controller.gamemode == gameMode.vs)
            SizedBox(
              height: 120,
              width: 120,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        getCharAsset(chrt.queen, player.white, false),
                        getCharAsset(chrt.queen, player.black, false)
                      ],
                    ),
                  ),
                  Text(
                    '${controller.wScore.value} - ${controller.bScore.value}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: getTextColor(),
                        fontSize: 42,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          Container(
            width: 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              border: Border.all(color: getTextColor(), width: 2),
            ),
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.all(10),
            child: Text(controller.getRandomGameOverScreenText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: getTextColor())),
          ),
          if (controller.gamemode != gameMode.online)
            SizedBox(
              height: 40,
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  playButtonSound();
                  controller.restartGame();
                },
                child: Text(l.g('Restart')),
              ),
            ),
          if (controller.gamemode == gameMode.online)
            SizedBox(
              height: 40,
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  playButtonSound();
                  controller.closeTheGame();
                },
                child: Text(l.g('Close')),
              ),
            ),
          if (controller.gamemode == gameMode.online)
            Obx(() {
              return SizedBox(
                  height: 100,
                  width: 170,
                  child: Center(
                    child: Text(
                        '${l.g('YourScore')}'
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
              style: TextStyle(color: getTextColor(), fontSize: 12)),
        ],
      ),
    );
  }
}
