import 'package:flutter/cupertino.dart';
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
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
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
                                ? () => controller.checkLogin()
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
          Obx(
            () => AnimatedPositioned(
              top: 40,
              right: controller.isOnline.value ? 10 : - 60,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutExpo,
              child: Obx(() {
                return FloatingActionButton(
                  heroTag: 'person',
                    child: authController.user.value == null
                        ? const Icon(CupertinoIcons.person)
                        : CircleAvatar(
                      backgroundImage: Image.network(
                          authController.user.value?.photoUrl ?? '')
                          .image,
                      radius: 30,
                    ),
                    onPressed: () => controller.showAuthDialog());
              }),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              top: controller.isLoading.value ? 10 : -MediaQuery.of(context).size.height,
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
          Obx(() =>
              AnimatedPositioned(
                top: controller.shouldShowDialog.value
                    ? 0
                    : -MediaQuery.of(context).size.height,
                curve: Curves.easeOutExpo,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  color: Colors.black54,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const LoginDialogView(),
                ),
              )),
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
                    FloatingActionButton(
                        heroTag: 'records',
                        child: const Icon(Icons.stacked_bar_chart),
                        onPressed: () {
                          Get.toNamed(Routes.HALL_OF_FAME);
                        }),
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
