import 'package:get/get.dart';

import '../controllers/tutorial_controller.dart';

class TutorialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TutorialController>(
      () => TutorialController(),
    );
  }
}
