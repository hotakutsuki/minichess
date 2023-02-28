import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:minichess/app/modules/auth/controllers/auth_controller.dart';
import 'package:minichess/app/modules/match/controllers/match_making_controller.dart';

import '../../../data/enums.dart';
import '../../../data/userDom.dart';
import '../controllers/match_controller.dart';
import '../widgets/ChessBoard.dart';
import '../widgets/Graveyard.dart';
import 'clock_view.dart';
import 'gameover_view.dart';

class MatchView extends GetView<MatchController> {
  MatchView({Key? key}) : super(key: key);
  MatchMakingController matchMakingController =
      Get.find<MatchMakingController>();
  AuthController authController = Get.find<AuthController>();

  Widget searchingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 20,
        ),
        const Text('looking for another player...'),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () => controller.closeTheGame(),
            child: const Text('cancel')),
      ],
    );
  }

  Widget? userAvatarMatch(User? user){
    if (user != null){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage:
            Image
                .network(user.photoUrl ?? '')
                .image,
            radius: 12,
          ),
          const SizedBox(width: 5,),
          Text(user.name),
          const SizedBox(width: 5,),
          Text('${user.score}'),
        ],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Center(
          child: Obx(() {
            return matchMakingController.searching.value
                ? searchingWidget()
                : RotatedBox(
                    quarterTurns:
                        matchMakingController.isHost.value != false ? 0 : 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RotatedBox(
                            quarterTurns: 0, child: userAvatarMatch(controller.invitedUser.value),
                        ),
                        RotatedBox(
                            quarterTurns: 2, child: ClockView(player.black)),
                        Graveyard(p: player.black),
                        RotatedBox(
                            quarterTurns:
                                controller.playersTurn == player.white ? 0 : 2,
                            child: ChessBoard(
                                matrix: controller.gs.value!.board,
                                playersTurn: controller.playersTurn)),
                        Graveyard(p: player.white),
                        ClockView(player.white),
                        RotatedBox(
                            quarterTurns: 0, child: userAvatarMatch(controller.hostUser.value),
                        ),
                      ],
                    ),
                  );
          }),
        ),
        Obx(
          () => !controller.isGameOver.value
              ? const SizedBox()
              : GameoverView(),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: FloatingActionButton(
            heroTag: 'close',
            backgroundColor: Colors.white,
            mini: true,
            onPressed: () => controller.closeTheGame(),
            //Get.offAllNamed(Routes.HOME),
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
