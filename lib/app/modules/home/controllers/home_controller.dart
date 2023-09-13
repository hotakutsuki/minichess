import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../../data/enums.dart';
import '../../../routes/app_pages.dart';
import '../../../services/database.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/views/login_dialog_view.dart';
import '../../../utils/utils.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  late FirebaseMessaging messaging;
  var isOnline = false.obs;
  var isLoading = true.obs;
  var shouldShowDialog = false.obs;
  final AuthController authController = Get.find<AuthController>();
  var withSound = false.obs;
  final player = AudioPlayer();
  late final AnimationController logoController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  bool isVolumeZero = false;
  void setMode(gameMode mode) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    Get.toNamed(Routes.MATCH, arguments: mode);
    // isLoading.value = false;
  }

  Future<void> goToUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void tryMultiplayer() {
    if (authController.user.value == null) {
      showAuthDialog();
    } else {
      setMode(gameMode.online);
    }
  }

  void playTitleSong() async {
    if (!withSound.value) {
      return;
    }
    stopTitleSong();
    await Future.delayed(const Duration(milliseconds: 800));
    player.play(AssetSource('sounds/titlescreen.mp3'));
    player.setReleaseMode(ReleaseMode.loop);
    resumeSong();
  }

  void playBattleSong() async {
    if (!withSound.value) {
      return;
    }
    stopTitleSong();
    await Future.delayed(const Duration(milliseconds: 800));
    player.play(AssetSource('sounds/battle.mp3'));
    player.setReleaseMode(ReleaseMode.loop);
    resumeSong();
  }

  void resumeSong() async {
    fadeSound(1,0,player,800);
    isVolumeZero = false;
  }

  void stopTitleSong() {
    if (!isVolumeZero){
      fadeSound(0,1,player,800);
    }
    isVolumeZero = true;
  }

  void showAuthDialog() {
    Get.dialog(const LoginDialogView(), barrierDismissible: true);
  }

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  toggleSound() {
    withSound.value = !withSound.value;
    if(withSound.value) {
      playTitleSong();
    } else {
      stopTitleSong();
    }
  }

  removeLatcher() async {
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
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
      if (kIsWeb){
        dbController.recordToken(token);
      } else {
        messaging.subscribeToTopic("newMatches");
      }
    }

    if (authController.user.value == null) {
      authController.loading.value = true;
      await Future.delayed(const Duration(milliseconds: 1000));
      await authController.trySilentLogin();
      authController.loading.value = false;
    }

    withSound.value = !kIsWeb;

    super.onReady();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused){
      stopTitleSong();
    }
    if (state == AppLifecycleState.resumed && withSound.value){
      resumeSong();
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
