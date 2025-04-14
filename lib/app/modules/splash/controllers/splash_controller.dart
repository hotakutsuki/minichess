import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/enums.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    //check if language is set
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? language = prefs.getString(sharedPrefs.language.name);

    if (language == null) {
      Get.offAllNamed(Routes.LANGUAGE);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
