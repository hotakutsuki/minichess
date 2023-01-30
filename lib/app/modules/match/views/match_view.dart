import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:minichess/app/routes/app_pages.dart';

import '../../../data/enums.dart';
import '../../../utils/gameObjects/tile.dart';
import '../controllers/match_controller.dart';
import '../widgets/ChessBoard.dart';
import '../widgets/Graveyard.dart';
import 'clock_view.dart';
import 'gameover_view.dart';

class MatchView extends GetView<MatchController> {
  const MatchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Center(
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotatedBox(quarterTurns: 2, child: ClockView(player.black)),
                Graveyard(p: player.black),
                RotatedBox(
                    quarterTurns: controller.playersTurn == player.white
                        ? 0
                        : 2,
                    child: ChessBoard(
                        matrix: controller.gs.value.board as List<List<Tile>>,
                        playersTurn: controller.playersTurn)),
                Graveyard(p: player.white),
                ClockView(player.white),
              ],
            );
          }),
        ),
        !controller.isGameOver
            ? const SizedBox()
            : const GameoverView(),
        Positioned(
          top: 8,
          right: 8,
          child: FloatingActionButton(
            heroTag: 'close',
            backgroundColor: Colors.white,
            mini: true,
            onPressed: () => Get.offAllNamed(Routes.HOME),
            child: const Icon(Icons.close, color: Colors.black87),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: FloatingActionButton(
            heroTag: 'restart',
            backgroundColor: Colors.white,
            mini: true,
            onPressed: controller.restartGame,
            child: const Icon(CupertinoIcons.refresh, color: Colors.black87),
          ),
        )
      ]),
    );
  }
}
