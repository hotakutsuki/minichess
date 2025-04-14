import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../data/enums.dart';
import '../../../utils/utils.dart';
import '../../language/controllers/language_controller.dart';
import '../controllers/tutorial_controller.dart';

class TutorialPageMoonView extends GetView {
  TutorialPageMoonView({Key? key}) : super(key: key);

  TutorialController tControler = Get.find<TutorialController>();
  LanguageController l = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 48,
            child: Text(l.g('ButWatchOutIfTheMoonEclipsesYouLose'),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          ),
        ),
        Container(
          // height: 500,
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Container(
                  height: getScale(context) * 380,
                  width:  getScale(context) * 280,
                  color: Colors.black54,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: getScale(context) * 150,
                            height: getScale(context) * 150,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                              border: Border.all(color: whitePlayerColor, width: 5),
                            ),
                          ),
                        ),
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(whitePlayerColor, BlendMode.modulate),
                          child: Lottie.asset(
                            'assets/animations/moon.json',
                            width: getScale(context) * 180,
                            height: getScale(context) * 180,
                            controller: tControler.animController,
                          ),
                        ),
                      ],
                    ),
                ),
              ),
              Center(
                  child: SizedBox(
                      height: getScale(context) * 420,
                      child: Image.asset(
                        'assets/images/border.png',
                        fit: BoxFit.fitHeight,
                      ))),
            ],
          ),
        ),
      ],
    );
  }
}
