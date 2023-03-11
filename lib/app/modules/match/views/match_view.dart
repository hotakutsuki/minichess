import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/enums.dart';
import '../../../data/userDom.dart';
import '../controllers/match_controller.dart';
import '../widgets/ChessBoard.dart';
import '../widgets/Graveyard.dart';
import 'clock_view.dart';
import 'gameover_view.dart';

class MatchView extends GetView<MatchController> {
  MatchView({Key? key}) : super(key: key);

  Widget searchingWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
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
      ),
    );
  }

  Widget? userAvatarMatch(User? user) {
    if (user != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: Image.network(user.photoUrl ?? '').image,
            radius: 12,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(user.name),
          const SizedBox(
            width: 5,
          ),
          Text('${user.score}'),
        ],
      );
    }
    return null;
  }

  bool isOnline() {
    return controller.gamemode == gameMode.online;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Center(
          child: Obx(() {
            return Stack(
              children: [
                RotatedBox(
                  quarterTurns: isOnline() &&
                          controller.isHost.value == false
                      ? 2
                      : 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RotatedBox(
                        quarterTurns: isOnline() &&
                                controller.isHost.value ==
                                    true
                            ? 0
                            : 2,
                        child: userAvatarMatch(controller.invitedUser.value),
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
                        quarterTurns: isOnline() &&
                                controller.isHost.value ==
                                    true
                            ? 0
                            : 2,
                        child: userAvatarMatch(controller.hostUser.value),
                      ),
                    ],
                  ),
                ),
                isOnline() && controller.searching.value
                    ? searchingWidget()
                    : const SizedBox(),
              ],
            );
          }),
        ),
        Obx(
          () =>
              !controller.isGameOver.value ? const SizedBox() : GameoverView(),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: FloatingActionButton(
            heroTag: 'close',
            backgroundColor: Colors.white,
            mini: true,
            onPressed: controller.closeTheGame,
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
