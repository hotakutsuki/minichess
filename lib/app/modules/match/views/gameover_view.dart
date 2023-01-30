import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:minichess/app/data/enums.dart';

import '../../../utils/utils.dart';
import '../controllers/match_controller.dart';

class GameoverView extends GetView<MatchController> {
  const GameoverView({Key? key}) : super(key: key);

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
          Text('Winner: ${controller.winner == player.white ? 'White' : 'Black'}',
              style: TextStyle(
                  color: getTextColor(),
                  fontSize: 48,
                  fontWeight: FontWeight.bold)),
          SizedBox(
              width: 250, height: 250, child: getImage(chrt.queen, controller.winner)),
          Text(
            controller.gamemode != gameMode.solo ? '' : 'W   B\n${controller.wScore} - ${controller.bScore}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: getTextColor(),
                fontSize: 42,
                fontWeight: FontWeight.bold),
          ),
          Text('GameId: ${DateTime.now().millisecondsSinceEpoch.toString()}',
              style: TextStyle(color: getTextColor())),
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
        ],
      ),
    );
  }
}
