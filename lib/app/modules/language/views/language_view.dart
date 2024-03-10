import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inti_the_inka_chess_game/app/modules/language/views/select_languaje_widget.dart';
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
          //to force cache tale page 1:
          SizedBox(
            height: 1,
            width: 1,
            child: Column(
              children: [
                Image.asset('assets/images/tale/SC1/bg4.png'),
                Image.asset('assets/images/tale/SC1/bg3.png'),
                Image.asset('assets/images/tale/SC1/bg2.png'),
                Image.asset('assets/images/tale/SC1/bg1.png'),
                Image.asset('assets/images/tale/SC1/ch.png'),
              ],
            ),
          ),
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
                                angle: controller.logoController.value * 2 *
                                    pi / 6,
                                child: child,
                              );
                            },
                            child: SizedBox(
                                height: 100,
                                child: Icon(Icons.settings, size: 100,
                                  color: brackgroundColor,)),
                          ),
                          const Divider(height: 20, color: Colors.transparent,),
                          LanguageSelectionWidget(),
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
                              ? controller.g('WithSound') : controller.g(
                              'WithOutSound'),
                            style: const TextStyle(fontSize: 14),),
                          const Divider(height: 50, color: Colors.transparent,),
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                playButtonSound();
                                controller.goToHomeScreen();
                              },
                              child: Text(controller.g('Start'),),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              )),
            Obx(() {
              if (controller.step.value == 2) {
                return const SizedBox();
              }
              return AnimatedBuilder(
                animation: controller.logoController,
                builder: (_, child) {
                  return Opacity(
                    opacity: controller.step.value == 0 ? 1 : controller.step
                        .value == 1 ? 1 - controller.logoController.value : 0,
                    child: child,
                  );
                },
                child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    color: Colors.black,
                    child: Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(controller.g('Loading')),
                            AnimatedBuilder(
                                animation: controller.logoController,
                                builder: (_, child) {
                                  return CircularProgressIndicator(
                                    color: Colors.white,
                                    value: controller.step.value != 0
                                        ? 1
                                        : controller.logoController.value,
                                  );
                                }
                            ),
                          ],
                        ),
                      ),
                    )
                ),
              );
            })
        ],
      ),
    );
  }
}
