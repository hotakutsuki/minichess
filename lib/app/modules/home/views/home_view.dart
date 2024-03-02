import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inti_the_inka_chess_game/app/modules/home/views/welcome_view.dart';
import 'dart:math';
import '../../../data/enums.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/gameObjects/BackgroundController.dart';
import '../../../utils/utils.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../language/controllers/language_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/intro_tale_controller.dart';
import 'intro_tale_view.dart';

class HomeView extends GetView<HomeController> with WidgetsBindingObserver {
  HomeView({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();
  BackgroundController backgroundController = Get.find<BackgroundController>();
  IntroTaleController taleController = Get.find<IntroTaleController>();
  LanguageController l = Get.find<LanguageController>();

  PopupMenuItem<difficult> PopupMenuItemG(difficult diff) {
    return PopupMenuItem(
        padding: const EdgeInsets.all(0),
        value: diff,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
            width: double.infinity,
            color: controller.diff.value == diff
                ? brackgroundColorLightTrans
                : null,
            child: Text(diff.name.capitalizeFirst!)));
  }

  @override
  Widget build(BuildContext context) {
    controller.removeLatcher();
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(alignment: Alignment.center, children: [
            backgroundController.backGround(context),
            Transform.scale(
              scale: getScale(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l.g('IntiTheInkaChessGame'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white38)),
                  AnimatedBuilder(
                    animation: controller.logoController,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: controller.logoController.value * 2 * pi / 8,
                        child: child,
                      );
                    },
                    child: SizedBox(
                        height: 100,
                        child: Image.asset('assets/images/pieces/wkings.png')),
                  ),
                  Obx(() {
                    return SizedBox(
                      height: 250,
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: Stack(
                              alignment: Alignment.center,
                              fit: StackFit.expand,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    controller.setMode(gameMode.solo);
                                    playButtonSound();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(l.g('VsPc')),
                                      Obx(() {
                                        return Text(
                                          '(${controller.diff.value.name.capitalizeFirst!})',
                                          style: const TextStyle(fontSize: 8),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: SizedBox(
                                    width: 30,
                                    height: 40,
                                    child: PopupMenuButton(
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItemG(difficult.easy),
                                        PopupMenuItemG(difficult.normal),
                                        PopupMenuItemG(difficult.hard),
                                      ],
                                      onSelected: (difficult value) {
                                        controller.setDifficult(value);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                              right: Radius.circular(4),
                                            ),
                                            border: Border.all(
                                                color: Colors.white54),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                playButtonSound();
                                controller.setMode(gameMode.vs);
                              },
                              child: Text(l.g('2Players')),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: controller.isOnline.value
                                  ? () {
                                      authController.tryStartMultuplayer = true;
                                      playButtonSound();
                                      controller.tryMultiplayer();
                                    }
                                  : null,
                              child: Text(l.g('Online')),
                            ),
                          ),
                          if (kDebugMode)
                            SizedBox(
                              height: 40,
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  playButtonSound();
                                  controller.setMode(gameMode.training);
                                },
                                child: Text(l.g('Training')),
                              ),
                            ),
                          Text(
                              authController.user.value != null
                                  ? '${l.g('Score')}${authController.user.value?.score}'
                                  : '',
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color : Colors.white60))
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            if (kIsWeb)
              Obx(
                () => AnimatedPositioned(
                  bottom: 30,
                  left: (controller.isOnline.value) ? 10 : -60,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutExpo,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          FloatingActionButton(
                            heroTag: 'gplay',
                            mini: true,
                            onPressed: () {
                              controller.goToUrl(
                                  'https://play.google.com/store/apps/details?id=com.hotakutsuki.minichess');
                            },
                            backgroundColor: Colors.black87,
                            child: SizedBox(
                                width: 25,
                                height: 25,
                                child: Image.asset('assets/images/gplay.png')),
                          ),
                          const SizedBox(width: 10),
                          FloatingActionButton(
                            heroTag: 'appstore',
                            mini: true,
                            onPressed: () {
                              controller.goToUrl(
                                  'https://apps.apple.com/ec/app/inti-the-inka-chess-game/id6468368257');
                            },
                            backgroundColor: Colors.black87,
                            child: SizedBox(
                                width: 25,
                                height: 25,
                                child: Image.asset('assets/images/appstorelogo.png')),
                          ),
                        ],
                      ),
                      Text(l.g('SenpaiNoticeMe')),
                    ],
                  ),
                ),
              ),
            Obx(
              () => AnimatedPositioned(
                top: 40,
                right: controller.isOnline.value ? 10 : -60,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutExpo,
                child: Obx(() {
                  return Column(
                    children: [
                      FloatingActionButton(
                          heroTag: 'person',
                          mini: true,
                          child: authController.loading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : authController.user.value == null
                                  ? const Icon(CupertinoIcons.person)
                                  : CircleAvatar(
                                      backgroundColor: brackgroundColor,
                                      backgroundImage:
                                          authController.user.value?.photoUrl ==
                                                  null
                                              ? null
                                              : Image.network(authController
                                                      .user.value!.photoUrl!)
                                                  .image,
                                      radius: 30,
                                      child: authController
                                                  .user.value?.photoUrl ==
                                              null
                                          ? Text(
                                              authController.user.value!.name[0]
                                                  .toUpperCase(),
                                              style:
                                                  const TextStyle(fontSize: 30),
                                            )
                                          : null,
                                    ),
                          onPressed: () {
                            authController.tryStartMultuplayer = false;
                            controller.showAuthDialog();
                          }),
                      Text(authController.user.value?.name ??l.g('Account')),
                    ],
                  );
                }),
              ),
            ),
            Obx(
              () => AnimatedPositioned(
                top: controller.firstTime.value
                    ? 10
                    : -MediaQuery.of(context).size.height,
                left: 5,
                curve: Curves.easeOutExpo,
                duration: const Duration(milliseconds: 500),
                child: WelcomeView(),
              ),
            ),
            Obx(() => AnimatedPositioned(
                  top: controller.showTale.value ? 0
                      : -MediaQuery.of(context).size.height,
                  curve: Curves.easeOutExpo,
                  duration: const Duration(milliseconds: 500),
                  child: const IntroTaleView(),
                )),
            Obx(
              () => AnimatedPositioned(
                top: controller.isLoading.value
                    ? 10
                    : -MediaQuery.of(context).size.height,
                left: 5,
                curve: Curves.easeOutExpo,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: brackgroundColorSolid,
                  ),
                  width: MediaQuery.of(context).size.width - 10,
                  height: MediaQuery.of(context).size.height - 20,
                  child: Center(
                      child: SizedBox(
                          height: 25,
                          child:
                              Image.asset('assets/images/pieces/wkingd.png'))),
                ),
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: Stack(children: [
        Obx(
          () => AnimatedPositioned(
            right: controller.isLoading.value || controller.firstTime.value || controller.showTale.value
                ? -100
                : 0,
            bottom: 0,
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 500),
            child: SizedBox(
              height: 320,
              child: Column(
                children: [
                  Column(
                    children: [
                      FloatingActionButton(
                          heroTag: 'Story',
                          mini: true,
                          onPressed: taleController.showTale,
                          child: const Icon(Icons.movie_creation_outlined)),
                      Text(l.g('Story')),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                          heroTag: 'sound',
                          mini: true,
                          onPressed: controller.toggleSound,
                          child: controller.withSound.value
                              ? const Icon(Icons.volume_up)
                              : const Icon(CupertinoIcons.volume_off)),
                      Text(l.g('Sound')),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (controller.isOnline.value)
                    Column(
                      children: [
                        FloatingActionButton(
                            heroTag: 'records',
                            mini: true,
                            child: const Icon(Icons.stacked_bar_chart),
                            onPressed: () {
                              Get.toNamed(Routes.HALL_OF_FAME);
                            }),
                        Text(l.g('Fame')),
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                          heroTag: 'tutorial',
                          mini: true,
                          child: const Icon(CupertinoIcons.question),
                          onPressed: () {
                            Get.toNamed(Routes.TUTORIAL);
                          }),
                      Text(l.g('HowToPlay')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
