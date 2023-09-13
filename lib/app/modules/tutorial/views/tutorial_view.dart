import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inti_the_inka_chess_game/app/modules/tutorial/views/tutorial_page_moon_view.dart';
import '../controllers/tutorial_controller.dart';

class TutorialView extends GetView<TutorialController> {
  const TutorialView({Key? key}) : super(key: key);

  Widget backGround() {
    return SizedBox.expand(
      child: Image.asset(
        'assets/images/backgrounds/bg2.png',
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            backGround(),
            Column(
              children: [
                AppBar(
                  elevation: 0,
                  title: const Text(
                    'Tutorial',
                    style: TextStyle(color: Colors.white70),
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
                      controller.getPage(
                          '1', 'Tap on a tile to select it.', context),
                      controller.getPage(
                          '2',
                          'Tap on any of the highlighted tiles to move.',
                          context),
                      controller.getPage(
                          '3', 'Tap on an enemy tile to take it.', context),
                      controller.getPage(
                          '4',
                          'When a piece is taken, it goes to you "graveyard".',
                          context),
                      controller.getPage(
                          '5',
                          'You can invoke pieces from your "graveyard".',
                          context),
                      controller.getPage(
                          '6',
                          'Reach to the top to transform a Snake into a Cougar.',
                          context),
                      controller.getPage('7', 'Take the Inti to win.', context),
                      TutorialPageMoonView(),
                      controller.getPage(
                          '8', 'These are the moves of the Tower.', context),
                      controller.getPage(
                          '9', 'These are the moves of the Condor.', context),
                      controller.getPage(
                          '10', 'These are the moves of the Cougar.', context),
                      controller.getPage(
                          '11', 'These are the moves of the Inti.', context),
                    ],
                  ),
                ),
                Container(
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
