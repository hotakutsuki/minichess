import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:minichess/app/modules/auth/controllers/auth_controller.dart';
import '../../../data/enums.dart';
import '../../../routes/app_pages.dart';
import '../../auth/views/login_dialog_view.dart';
import '../../match/controllers/match_making_controller.dart';

class HomeController extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final AuthController authController = Get.find<AuthController>();

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
  void onReady() async {
    print('ready home controller $authController');
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    String? token = await messaging.getToken(
      vapidKey: "BMnLhmaBDEW0nIVy5544WoLoHt4UFgCZsi2RBKGOSy_8dJbyW0UVXwxpXvWcpCfzPRStgLOHvALVu34ZDb6CcmM",
    );

    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
