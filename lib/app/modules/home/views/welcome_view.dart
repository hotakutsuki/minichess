import '../../../routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums.dart';
import '../../../utils/utils.dart';

class WelcomeView extends GetView {
  const WelcomeView({super.key});

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
                const Text('Hello there!',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade),
                const Text(
                    "Looks like is your first time here.\nWanna know how to play?",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
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
                            controller.setFirstTime(false);
                          },
                          child: const Text(
                            'How to Play',
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
                            controller.setFirstTime(false);
                          },
                          child: const Text(
                            'I Can Handle it',
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
