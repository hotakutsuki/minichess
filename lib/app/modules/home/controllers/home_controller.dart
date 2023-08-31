import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../../data/enums.dart';
import '../../../routes/app_pages.dart';
import '../../../services/database.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/views/login_dialog_view.dart';
import '../../../utils/utils.dart';

class HomeController extends GetxController {
  late FirebaseMessaging messaging;
  var isOnline = false.obs;
  var isLoading = true.obs;
  var shouldShowDialog = false.obs;
  final AuthController authController = Get.find<AuthController>();
  final player = AudioPlayer();

  void setMode(gameMode mode) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    Get.toNamed(Routes.MATCH, arguments: mode);
    // isLoading.value = false;
  }

  void tryMultiplayer() {
    if (authController.user.value == null) {
      showAuthDialog();
    } else {
      setMode(gameMode.online);
    }
  }

  void playTitleSong() async {
    var position = await player.getCurrentPosition();
    if (position == null || position.inSeconds == 0){
      print('playing...');
      player.play(AssetSource('sounds/titlescreen.mp3'));
      player.setReleaseMode(ReleaseMode.loop);
    }
  }

  void showAuthDialog() {
    Get.dialog(const LoginDialogView(), barrierDismissible: true);
  }

  @override
  void onInit() async {
    print('home controller on init');
    super.onInit();
  }

  removeLatcher() async {
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }

  @override
  void onReady() async {
    print('home controller ready');
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
    print('closgin home controller');
    super.onClose();
  }
}
