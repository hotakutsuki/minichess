import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/gameObjects/BackgroundController.dart';
import '../../../utils/utils.dart';
import '../../../data/enums.dart';
import '../controllers/language_controller.dart';

class LanguageView extends GetView<LanguageController> {
  LanguageView({Key? key}) : super(key: key);

  BackgroundController backgroundController = Get.find<BackgroundController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backgroundController.backGround(context),
          Center(
            child: SizedBox(
              height: 250,
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: controller.logoController,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: controller.logoController.value * 2 * pi / 8,
                        child: child,
                      );
                    },
                    child: SizedBox(
                        height: 100,
                        child: Image.asset('assets/images/pieces/wkings.png')),
                  ),
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        playButtonSound();
                        controller.setLanguage(languages.en);
                        controller.goToHomeScreen();
                      },
                      child: const Text(
                        'English',
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.transparent,
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        playButtonSound();
                        controller.setLanguage(languages.es);
                        controller.goToHomeScreen();
                      },
                      child: const Text(
                        'Español',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
