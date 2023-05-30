import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:minichess/app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/foundation.dart';
import '../../../data/enums.dart';
import '../../../routes/app_pages.dart';
import '../../../services/database.dart';
import '../../auth/views/login_dialog_view.dart';
import '../../../utils/utils.dart';

class HomeController extends GetxController {
  late FirebaseMessaging messaging;
  var isOnline = false.obs;
  var isLoading = false.obs;
  var shouldShowDialog = false.obs;
  final AuthController authController = Get.find<AuthController>();

  void setMode(gameMode mode) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    Get.toNamed(Routes.MATCH, arguments: mode);
    isLoading.value = false;
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
    // shouldShowDialog.value = true;
    Get.dialog(const LoginDialogView(), barrierDismissible: true);
  }

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    isOnline.value = await isConnected();
    if (isOnline.value) {
      messaging = FirebaseMessaging.instance;
    }
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // print('User granted permission: ${settings.authorizationStatus}');
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      String? token = await messaging.getToken(
        vapidKey: "BMnLhmaBDEW0nIVy5544WoLoHt4UFgCZsi2RBKGOSy_8dJbyW0UVXwxpXvWcpCfzPRStgLOHvALVu34ZDb6CcmM",
      );
      DatabaseController dbController = Get.find<DatabaseController>();
      if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS){
        messaging.subscribeToTopic("newMatches");
      } else {
        dbController.recordToken(token);
      }
    }

    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
