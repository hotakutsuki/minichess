import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../views/tutorial_page_view.dart';

class TutorialController extends GetxController {
  final pageController = PageController(
    initialPage: 0,
  );

  var diablePrev = true.obs;
  var disableNext = false.obs;

  Widget getPage(String image, String text) {
    return TutorialPageView(image, text);
  }

  @override
  void onInit() {
    pageController.addListener(() {
      diablePrev.value = pageController.page == 0;
      disableNext.value = pageController.page == 8;
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
