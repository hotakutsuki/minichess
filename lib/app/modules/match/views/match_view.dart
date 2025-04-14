import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/enums.dart';
import '../../../data/userDom.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/gameObjects/BackgroundController.dart';
import '../../../utils/utils.dart';
import '../../language/controllers/language_controller.dart';
import '../controllers/match_controller.dart';
import '../widgets/ChessBoard.dart';
import '../widgets/Graveyard.dart';
import 'clock_view.dart';
import 'gameover_view.dart';

class MatchView extends GetView<MatchController> {
  MatchView({Key? key}) : super(key: key);
  BackgroundController backgroundController = Get.find<BackgroundController>();
  LanguageController l = Get.find<LanguageController>();

  Widget searchingWidget() {
    return Obx(() => isOnline() && controller.searching.value
        ? Container(
            width: double.infinity,
            height: double.infinity,
            color: brackgroundColorSolid,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: brackgroundColorLight),
                const SizedBox(
                  height: 20,
                ),
                Text(l.g('LookingForAnotherPlayer')),
                Text(controller.searchingSeconds.value),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      playButtonSound();
                      controller.closeTheGame();
                    },
                    child: Text(l.g('Cancel'))),
              ],
            ),
          )
        : RotatedBox(
            quarterTurns: controller.searching.value ? 0 : 1,
            child: null,
          ));
  }

  Widget userAvatarMatch(User? user, bool isHostUser) {
    if (user != null) {
      return RotatedBox(
        quarterTurns: !controller.isHost.value ^ isHostUser ? 0 : 2,
        child: Container(
          height: 30,
          width: 280,
          decoration: BoxDecoration(
            color: brackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: RotatedBox(
            quarterTurns: !controller.isHost.value ^ isHostUser ? 0 : 2,
            child: Row(
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
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  bool isOnline() {
    return controller.gamemode == gameMode.online;
  }

  Widget clock(int turns, player player) {
    return RotatedBox(quarterTurns: turns, child: ClockView(player));
  }

  Widget board() {
    return Stack(
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: const SizedBox(
                width: 320,
                height: 450,
              ),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 300,
            height: 400,
            child: Stack(
              children: [
                Positioned.fill(
                    top: 3, child: Image.asset('assets/images/board.png')),
                RotatedBox(
                    quarterTurns:
                        controller.playersTurn == player.white ? 0 : 2,
                    child: ChessBoard(
                        matrix: controller.gs.value!.board,
                        playersTurn: controller.playersTurn)),
              ],
            ),
          ),
        ),
        IgnorePointer(
          child: Center(
            child: SizedBox(
              width: 330,
              height: 450,
              child: Image.asset('assets/images/border.png'),
            ),
          ),
        ),
      ],
    );
  }

  Widget gameOver() {
    return Obx(
      () => !controller.isGameOver.value ? const SizedBox() : GameoverView(),
    );
  }

  Widget transitionScreen(context) {
    return Obx(
      () => AnimatedPositioned(
        top: controller.isLoading.value
            ? 10
            : -MediaQuery.of(context).size.height,
        left: 5,
        curve: Curves.easeOutExpo,
        duration: const Duration(milliseconds: 500),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: brackgroundColorSolid,
          ),
          width: MediaQuery.of(context).size.width - 10,
          height: MediaQuery.of(context).size.height - 20,
          child: Center(
              child: SizedBox(
                  height: 25,
                  child: Image.asset('assets/images/pieces/wkings.png'))),
        ),
      ),
    );
  }

  Widget closeButton() {
    return FloatingActionButton(
      heroTag: 'close${getRandomInt(100)}',
      backgroundColor: brackgroundColor,
      mini: true,
      onPressed: controller.closeTheGame,
      child: const Icon(Icons.close, color: Colors.white),
    );
  }

  Widget tutorialButton() {
    return FloatingActionButton(
      heroTag: 'tutorial${getRandomInt(100)}',
      backgroundColor: brackgroundColor,
      mini: true,
      onPressed: () {
        Get.toNamed(Routes.TUTORIAL);
      },
      child: const Icon(CupertinoIcons.question, color: Colors.white),
    );
  }

  Widget restartButton() {
    return FloatingActionButton(
      heroTag: 'restart${getRandomInt(100)}',
      backgroundColor: brackgroundColor,
      mini: true,
      onPressed: controller.restartGame,
      child: const Icon(CupertinoIcons.refresh, color: Colors.white),
    );
  }

  Widget gameZone() {
    return Center(
      child: Obx(() {
        return Stack(
          children: [
            RotatedBox(
              quarterTurns:
                  isOnline() && controller.isHost.value == false ? 2 : 0,
              child: SizedBox(
                height: 540,
                width: 360,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    board(),
                    Positioned(top: 0, child: Graveyard(p: player.black)),
                    Positioned(bottom: 0, child: Graveyard(p: player.white)),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  BorderSide pannelBorder() {
    return BorderSide(color: brackgroundColorLight, width: 3);
  }

  Widget buttonPannel(player p) {
    return RotatedBox(
      quarterTurns: !controller.isHost.value ^ (p == player.white) ? 0 : 2,
      child: Container(
        height: 60,
        width: 300,
        decoration: BoxDecoration(
          color: brackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 50, width: 50, child: ClockView(p)),
            Obx(() {
              return Text(
                '▲ ▼\n${p == player.white ? controller.wScore : controller.bScore}   ${p != player.white ? controller.wScore : controller.bScore}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              );
            }),
            tutorialButton(),
            restartButton(),
            closeButton(),
          ],
        ),
      ),
    );
  }

  Widget pcInfo() {
    return Container(
      height: 25,
      width: 150,
      decoration: BoxDecoration(
        color: brackgroundColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              '${l.g('Difficult')}${controller.aiController.diff.value.name.capitalizeFirst ?? ''}'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              backgroundController.backGround(context),
              SizedBox.expand(
                child: Stack(alignment: Alignment.center, children: [
                  Positioned(
                    top: 0,
                    child: Column(
                      children: [
                        Obx(() => buttonPannel(controller.isHost.value
                            ? player.black
                            : player.white)),
                        Obx(() {
                          return userAvatarMatch(
                            controller.isHost.value
                                ? controller.invitedUser.value
                                : controller.hostUser.value,
                            controller.isHost.value ? false : true,
                          );
                        }),
                        if (controller.gamemode == gameMode.solo ||
                            controller.gamemode == gameMode.training)
                          Obx(() {
                            return controller.aiControllerInitialized.value
                                ? pcInfo()
                                : const SizedBox();
                          }),
                      ],
                    ),
                  ),
                  Transform.scale(
                      scale: getFullScale(context), child: gameZone()),
                  Positioned(
                    bottom: 0,
                    child: Column(
                      children: [
                        Obx(() {
                          return userAvatarMatch(
                            controller.isHost.value
                                ? controller.hostUser.value
                                : controller.invitedUser.value,
                            controller.isHost.value ? true : false,
                          );
                        }),
                        Obx(() => buttonPannel(controller.isHost.value
                            ? player.white
                            : player.black)),
                      ],
                    ),
                  )
                ]),
              ),
              if (kDebugMode)
                FloatingActionButton(
                    child: const Icon(Icons.pause),
                    onPressed: () {
                      controller.pausa.value = !controller.pausa.value;
                    }),
              gameOver(),
              transitionScreen(context),
              searchingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
