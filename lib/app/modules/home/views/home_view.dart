import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minichess/app/modules/auth/controllers/auth_controller.dart';
import 'package:minichess/app/routes/app_pages.dart';
import '../../../data/enums.dart';
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Minichess',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
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
                          onPressed: () => controller.checkLogin(),
                          child: const Text(
                            'Multiplayer online',
                          ),
                        ),
                      ),
                      if(authController.user.value != null) Text(
                          'score: ${authController.user.value?.score}',
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold))
                      // SizedBox(
                      //   height: 40,
                      //   width: 150,
                      //   child: ElevatedButton(
                      //     onPressed: () => setMode(context, gameMode.training),
                      //     child: const Text(
                      //       'Training',
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              }),
            ],
          ),
          Positioned(
            top: 40,
            right: 10,
            child: Obx(() {
              return FloatingActionButton(
                  child: authController.user.value == null
                      ? const Icon(CupertinoIcons.person)
                      : CircleAvatar(
                    backgroundImage: Image
                        .network(authController
                        .user.value?.photoUrl ??
                        '')
                        .image,
                    radius: 30,
                  ),
                  onPressed: () => controller.showAuthDialog());
            }),
          ),
        ]),
      ),
      floatingActionButton: SizedBox(
        height: 180,
        child: Column(
          children: [
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
    );
  }
}
