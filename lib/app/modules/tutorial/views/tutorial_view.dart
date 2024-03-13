import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inti_the_inka_chess_game/app/modules/tutorial/views/tutorial_page_moon_view.dart';
import '../../../utils/gameObjects/BackgroundController.dart';
import '../../language/controllers/language_controller.dart';
import '../controllers/tutorial_controller.dart';

class TutorialView extends GetView<TutorialController> {
  TutorialView({Key? key}) : super(key: key);
  BackgroundController backgroundController = Get.find<BackgroundController>();
  LanguageController l = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            backgroundController.backGround(context),
            Column(
              children: [
                AppBar(
                  elevation: 0,
                  title: Text(l.g('Tutorial'),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  backgroundColor: Colors.white10,
                  centerTitle: true,
                  actions: [
                    FloatingActionButton(
                      elevation: 0,
                      heroTag: 'close',
                      mini: true,
                      onPressed: () => Get.back(closeOverlays: true),
                      child: const Icon(Icons.close, color: Colors.white60),
                    )
                  ],
                ),
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    children: [
                      controller.getPage('1', l.g('TapOnTileSelect'), context),
                      controller.getPage('2', l.g('TapOnHighlightedTiles'), context),
                      controller.getPage('3', l.g('TapOnEnemyTile'), context),
                      controller.getPage('4', l.g('WhenTakenGoesGraveyard'), context),
                      controller.getPage('5', l.g('YouCanInvokePiecesFromYourGraveyard'), context),
                      controller.getPage('6', l.g('ReachToTheTopToTransformASnakeIntoACougar'), context),
                      controller.getPage('7', l.g('TakeTheIntiToWin'), context),
                      TutorialPageMoonView(),
                      controller.getPage('8', l.g('TheseAreTheMovesOfTheTower'), context),
                      controller.getPage('9', l.g('TheseAreTheMovesOfTheCondor'), context),
                      controller.getPage('10', l.g('TheseAreTheMovesOfTheCougar'), context),
                      controller.getPage('11', l.g('TheseAreTheMovesOfTheInti'), context),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              controller.pageController.previousPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutExpo);
                            },
                            child: const SizedBox(
                                height: 100,
                                child: Icon(
                                  Icons.arrow_left,
                                  size: 40,
                                ))),
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              controller.pageController.nextPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutExpo);
                            },
                            child: const SizedBox(
                                height: 100,
                                child: Icon(Icons.arrow_right, size: 40))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
