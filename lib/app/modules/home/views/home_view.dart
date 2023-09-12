import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../../../data/enums.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/utils.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    controller.removeLatcher();
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(alignment: Alignment.center, children: [
            SizedBox.expand(
              child: Image.asset(
                'assets/images/backgrounds/bg2.png',
                fit: BoxFit.cover,
              ),
            ),
            Transform.scale(
              scale: getScale(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Inti: The Inka\nChess Game',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white30)),
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
                            child: ElevatedButton(
                              onPressed: () {
                                controller.setMode(gameMode.solo);
                                playButtonSound();
                                },
                              child: const Text(
                                'Vs PC',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {playButtonSound();
                              controller.setMode(gameMode.vs);},
                              child: const Text(
                                '2 players',
                              ),
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
                              child: const Text(
                                'Multiplayer online',
                              ),
                            ),
                          ),
                          Text(
                              authController.user.value != null
                                  ? 'score: ${authController.user.value?.score}'
                                  : '',
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white60))
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
                    FloatingActionButton(
                      heroTag: 'gplay',
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
                    const Text('Senpai notice me'),
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
                      Text(authController.user.value?.name ?? 'Account'),
                    ],
                  );
                }),
              ),
            ),
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
                          child: Image.asset('assets/images/pieces/wkingd.png'))),
                ),
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: Stack(children: [
        Obx(
          () => AnimatedPositioned(
            right: !controller.isLoading.value ? 0 : -100,
            bottom: 0,
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 500),
            child: SizedBox(
              height: 280,
              child: Column(
                children: [
                  Column(
                    children: [
                      FloatingActionButton(
                          heroTag: 'sound',
                          onPressed: controller.toggleSound,
                          child: controller.withSound.value ?  const Icon(Icons.volume_up) : const Icon(CupertinoIcons.volume_off)
                      ),
                      const Text('Sound'),
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
                            child: const Icon(Icons.stacked_bar_chart),
                            onPressed: () {
                              Get.toNamed(Routes.HALL_OF_FAME);
                            }),
                        const Text('Fame'),
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                          heroTag: 'tutorial',
                          child: const Icon(CupertinoIcons.question),
                          onPressed: () {
                            Get.toNamed(Routes.TUTORIAL);
                          }),
                      const Text('How to play'),
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
