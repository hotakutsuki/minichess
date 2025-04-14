import 'package:inti_the_inka_chess_game/app/modules/home/controllers/home_controller.dart';

import '../../../routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums.dart';
import '../../../utils/utils.dart';
import '../../language/controllers/language_controller.dart';

class WelcomeView extends GetView {
  WelcomeView({super.key});

  final HomeController homeController = Get.find<HomeController>();
  final LanguageController l = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: brackgroundColorSemi,
      ),
      width: MediaQuery
          .of(context)
          .size
          .width - 10,
      height: MediaQuery
          .of(context)
          .size
          .height - 20,
      child: Center(
          child: SizedBox(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(l.g('HelloThere'),
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade),
                Text(
                    l.g('LooksLikeIsYourFirstTimeHere'),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                    overflow: TextOverflow.fade),
                SizedBox(
                    height: 25,
                    child:
                    Image.asset(
                        'assets/images/pieces/wkings.png')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 40,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            playButtonSound();
                            Get.toNamed(Routes.TUTORIAL);
                            homeController.setFirstTime(false);
                          },
                          child: Text(
                            l.g('ShowMeHow'), textAlign: TextAlign.center,
                          ),
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                        height: 40,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            playButtonSound();
                            homeController.setFirstTime(false);
                          },
                          child: Text(
                            l.g('ICanHandleIt'),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
