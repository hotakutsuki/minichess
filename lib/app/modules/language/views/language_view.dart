import 'dart:math';

import 'package:flutter/cupertino.dart';
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
              child: AlertDialog(
            backgroundColor: const Color.fromRGBO(255, 255, 255, .80),
            content: SizedBox(
              height: 350,
              width: 350,
              child: Obx(() {
                return SingleChildScrollView(
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
                            // child: Image.asset('assets/images/pieces/wkings.png')),
                            child: Icon(Icons.settings, size: 80, color: brackgroundColor,)),
                      ),
                      const Divider(height: 20, color: Colors.transparent,),
                      //add toggle buttons for language
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Obx(() =>
                                ToggleButtons(
                                  isSelected: [
                                    controller.language.value == languages.en,
                                    controller.language.value == languages.es,
                                  ],
                                  onPressed: (index) {
                                    controller.setLanguage(
                                        index == 0 ? languages.en : languages.es);
                                  },
                                  children: <Widget>[
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 0),
                                        child: const Text('English')
                                    ),
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 0),
                                        child: const Text('Español')),
                                  ],
                                )),
                          ]),
                      const Divider(height: 20, color: Colors.transparent,),
                      FloatingActionButton(
                          heroTag: 'sound',
                          mini: true,
                          onPressed: controller.homeController.toggleSound,
                          child: controller.homeController.withSound.value
                              ? const Icon(Icons.volume_up)
                              : const Icon(CupertinoIcons.volume_off)),
                      const Divider(height: 5, color: Colors.transparent,),
                      Text(controller.homeController.withSound.value
                          ? controller.g('WithOutSound') : controller.g('WithSound'), style: const TextStyle(fontSize: 14),),
                      const Divider(height: 20, color: Colors.transparent,),
                      SizedBox(
                        height: 40,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            playButtonSound();
                            controller.goToHomeScreen();
                          },
                          child: Text(controller.g('Continue'),),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          )),
        ],
      ),
    );
  }
}
