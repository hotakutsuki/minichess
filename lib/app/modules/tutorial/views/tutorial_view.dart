import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:minichess/app/routes/app_pages.dart';

import '../controllers/tutorial_controller.dart';

class TutorialView extends GetView<TutorialController> {
  const TutorialView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
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
          const Positioned(
              top: 24,
              child: Text('Tutorial',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500))),
          Positioned(
            left: 4,
            child: Obx(() {
              return FloatingActionButton(
                  backgroundColor: controller.diablePrev.value
                      ? Colors.grey
                      : Colors.deepPurple,
                  heroTag: 'back',
                  mini: true,
                  child: const Icon(Icons.arrow_left),
                  onPressed: () {
                    controller.pageController.previousPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease);
                  });
            }),
          ),
          Positioned(
            right: 4,
            child: Obx(() {
              return FloatingActionButton(
                  backgroundColor: controller.disableNext.value
                      ? Colors.grey
                      : Colors.deepPurple,
                  heroTag: 'forward',
                  mini: true,
                  child: const Icon(Icons.arrow_right),
                  onPressed: () {
                    controller.pageController.nextPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.bounceIn);
                  });
            }),
          ),
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
        ],
      ),
    );
  }
}
