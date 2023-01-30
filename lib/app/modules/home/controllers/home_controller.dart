import 'package:get/get.dart';
import 'package:minichess/app/modules/auth/controllers/auth_controller.dart';

import '../../../data/enums.dart';
import '../../../routes/app_pages.dart';
import '../../auth/views/login_dialog_view.dart';

class HomeController extends GetxController {
  final authController = Get.put(AuthController());

  void setMode(gameMode mode) {
    Get.toNamed(Routes.MATCH, arguments: mode);
  }

  void checkLogin() {
    if (authController.googleAccount.value == null) {
      showAuthDialog();
    } else {
      startNewMatch();
    }
  }

  void showAuthDialog(){
    Get.dialog(const LoginDialogView(), barrierDismissible: true);
  }

  void startNewMatch(){
    setMode(gameMode.online);
    //addMatch();
  }

  @override
  void onInit() {
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
