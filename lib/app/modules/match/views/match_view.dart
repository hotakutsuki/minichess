import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/enums.dart';
import '../../../data/userDom.dart';
import '../../../utils/utils.dart';
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
          Text(controller.searchingSeconds.value),
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

  Widget userInfo(Rxn<User> user) {
    return RotatedBox(
      quarterTurns: isOnline() && controller.isHost.value == true ? 0 : 2,
      child: userAvatarMatch(user.value),
    );
  }

  Widget clock(int turns, player player) {
    return RotatedBox(quarterTurns: turns, child: ClockView(player));
  }

  Widget board() {
    return SizedBox(
      width: 300,
      height: 400,
      child: Stack(
        children: [
          Image.asset('assets/images/board.png'),
          RotatedBox(
              quarterTurns: controller.playersTurn == player.white ? 0 : 2,
              child: ChessBoard(
                  matrix: controller.gs.value!.board,
                  playersTurn: controller.playersTurn)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Transform.scale(
        scale: getScale(context),
        child: Stack(children: [
          Center(
            child: Obx(() {
              return Stack(
                children: [
                  RotatedBox(
                    quarterTurns:
                        isOnline() && controller.isHost.value == false ? 2 : 0,
                    child: SizedBox(
                      height: 650,
                      width: 360,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          board(),
                          Positioned(top: 50, child: Graveyard(p: player.black)),
                          Positioned(
                              bottom: 50, child: Graveyard(p: player.white)),
                          Positioned(
                              top: 0, child: userInfo(controller.invitedUser)),
                          Positioned(
                              bottom: 0, child: userInfo(controller.hostUser)),
                          Positioned(top: 20, child: clock(2, player.black)),
                          Positioned(bottom: 20, child: clock(0, player.white)),
                        ],
                      ),
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
            top: 40,
            right: 8,
            child: FloatingActionButton(
              heroTag: 'close',
              backgroundColor: Colors.white,
              mini: true,
              onPressed: controller.closeTheGame,
              child: const Icon(Icons.close, color: Colors.black87),
            ),
          ),
          if (controller.gamemode != gameMode.online)
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
            ),
          Obx(() => AnimatedPositioned(
            top: controller.isLoading.value ? 10 : -MediaQuery.of(context).size.height,
            left: 5,
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 500),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.blueGrey,
              ),
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height - 20,
              child: Center(child: SizedBox(height: 25, child: Image.asset('assets/images/icon.png'))),
            ),
          ),
          )
        ]),
      ),
    );
  }
}
