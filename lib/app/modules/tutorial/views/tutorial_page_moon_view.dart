import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../data/enums.dart';
import '../controllers/tutorial_controller.dart';

class TutorialPageMoonView extends GetView {
  TutorialPageMoonView({Key? key}) : super(key: key);

  TutorialController tControler = Get.find<TutorialController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: SizedBox(
            height: 24,
            child: Text('But watch out. If the moon eclipses, you lose.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          ),
        ),
        Container(
          height: 500,
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Center(
                child: Container(
                    height: 420,
                    width: 310,
                    color: Colors.black54,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 170,
                            height: 170,
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
                            width: 200,
                            height: 200,
                            controller: tControler.animController,
                          ),
                        ),
                      ],
                    ),
                ),
              ),
              Center(child: Image.asset('assets/images/border.png')),
            ],
          ),
        ),
      ],
    );
  }
}
