import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/enums.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/utils.dart';
import '../controllers/tutorial_controller.dart';

class TutorialView extends GetView<TutorialController> {
  const TutorialView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/backgrounds/bg2.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
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
                      onPressed: () => Get.offAndToNamed(Routes.HOME),
                      child: const Icon(Icons.close, color: Colors.white60),
                    )
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     SizedBox(width: 40,),
                //     const Text('Tutorial', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
                //     FloatingActionButton(
                //       heroTag: 'close',
                //       backgroundColor: Colors.white,
                //       mini: true,
                //       onPressed: () => Get.offAllNamed(Routes.HOME),
                //       child: const Icon(Icons.close, color: Colors.black87),
                //     ),
                //   ],
                // ),
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    children: [
                      controller.getPage('1select', 'Tap on a tile to select it.'),
                      controller.getPage(
                          '2move', 'Tap on any of the highlighted tiles to move.'),
                      controller.getPage(
                          '3takepng', 'Tap on an enemy tile to take it.'),
                      controller.getPage(
                          '4grave', 'When a piece is taken, it goes to you graveyard.'),
                      controller.getPage(
                          '5revive', 'You can invoke pieces from your graveyard.'),
                      controller.getPage('6knigthpng',
                          'Reach to the top to transform a Pawn into a Knight.'),
                      controller.getPage('7win', 'Take the king to win.'),
                      controller.getPage('8clock',
                          'But watch out your clock. If it gets to 0, you lose.'),
                      controller.getPage('9moves', 'These are the valid moves.'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(() {
                        return FloatingActionButton(
                            backgroundColor: controller.diablePrev.value
                                ? Colors.grey
                                : brackgroundColor,
                            heroTag: 'back',
                            mini: true,
                            child: const Icon(Icons.arrow_left),
                            onPressed: () {
                              controller.pageController.previousPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutExpo);
                            });
                      }),
                      Obx(() {
                        return FloatingActionButton(
                            backgroundColor: controller.disableNext.value
                                ? Colors.grey
                                : brackgroundColor,
                            heroTag: 'forward',
                            mini: true,
                            child: const Icon(Icons.arrow_right),
                            onPressed: () {
                              controller.pageController.nextPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.bounceIn);
                            });
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
