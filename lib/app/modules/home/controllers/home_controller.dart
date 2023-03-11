import 'package:get/get.dart';
import 'package:minichess/app/modules/auth/controllers/auth_controller.dart';

import '../../../data/enums.dart';
import '../../../routes/app_pages.dart';
import '../../auth/views/login_dialog_view.dart';
import '../../match/controllers/match_making_controller.dart';

class HomeController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  // late MatchMakingController matchMakingController;

  void setMode(gameMode mode) {
    Get.toNamed(Routes.MATCH, arguments: mode);
  }

  void checkLogin() {
    if (authController.googleAccount.value == null) {
      showAuthDialog();
    } else {
      setMode(gameMode.online);
      // matchMakingController = Get.find<MatchMakingController>();
      // matchMakingController.startMatch();
    }
  }

  void showAuthDialog() {
    Get.dialog(LoginDialogView(), barrierDismissible: true);
  }

  @override
  void onInit() {
    print('initing home controller');
    super.onInit();
  }

  @override
  void onReady() {
    print('ready home controller $authController');
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
