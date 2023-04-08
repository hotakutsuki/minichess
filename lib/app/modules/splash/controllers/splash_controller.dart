import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
