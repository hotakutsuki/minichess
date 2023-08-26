import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minichess/app/modules/auth/controllers/auth_controller.dart';
import 'package:minichess/app/routes/app_pages.dart';
import '../../../data/enums.dart';
import '../../../utils/utils.dart';
import '../../auth/views/login_dialog_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(alignment: Alignment.center, children: [
          Transform.scale(
            scale: getScale(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Minichess',
                    style:
                        TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                Container(
                    height: 50,
                    child: SizedBox(
                        height: 25,
                        child: Image.asset('assets/images/icon.png'))),
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
                            onPressed: () => controller.setMode(gameMode.solo),
                            child: const Text(
                              'Vs PC',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () => controller.setMode(gameMode.vs),
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
                                    controller.tryMultiplayer();
                                  }
                                : null,
                            child: const Text(
                              'Multiplayer online',
                            ),
                          ),
                        ),
                        if (authController.user.value != null)
                          Text('score: ${authController.user.value?.score}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))
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
                    backgroundColor: Colors.white,
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
                                    backgroundColor: Colors.blueGrey,
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
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.blueGrey,
                ),
                width: MediaQuery.of(context).size.width - 10,
                height: MediaQuery.of(context).size.height - 20,
                child: Center(
                    child: SizedBox(
                        height: 25,
                        child: Image.asset('assets/images/icon.png'))),
              ),
            ),
          ),
          // Obx(() => AnimatedPositioned(
          //       top: controller.shouldShowDialog.value
          //           ? 0
          //           : -MediaQuery.of(context).size.height,
          //       curve: Curves.easeOutExpo,
          //       duration: const Duration(milliseconds: 500),
          //       child: Container(
          //         color: Colors.black54,
          //         width: MediaQuery.of(context).size.width,
          //         height: MediaQuery.of(context).size.height,
          //         child: const LoginDialogView(),
          //       ),
          //     )),
        ]),
      ),
      floatingActionButton: Stack(children: [
        Obx(
          () => AnimatedPositioned(
            right: !controller.isLoading.value ? 0 : -60,
            bottom: 0,
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 500),
            child: SizedBox(
              height: 180,
              child: Column(
                children: [
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
                    height: 12,
                  ),
                  FloatingActionButton(
                      heroTag: 'tutorial',
                      child: const Icon(CupertinoIcons.question),
                      onPressed: () {
                        Get.toNamed(Routes.TUTORIAL);
                      }),
                  const Text('Tutorial'),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
