import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:inti_the_inka_chess_game/app/utils/utils.dart';

import '../views/tutorial_page_view.dart';

class TutorialController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final pageController = PageController(
    initialPage: 0,
  );

  var diablePrev = true.obs;
  var disableNext = false.obs;

  late final AnimationController animController;

  Widget getPage(String image, String text, context) {
    return TutorialPageView(image, text);
  }

  @override
  void onInit() {
    pageController.addListener(() {
      diablePrev.value = pageController.page == 0;
      disableNext.value = pageController.page == 11;
    });

    animController = AnimationController(vsync: this);
    animController.duration = const Duration(seconds: 5);
    animController.animateTo(0.5);
    animController.repeat();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
