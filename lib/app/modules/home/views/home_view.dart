import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minichess/app/modules/tutorial/views/tutorial_view.dart';
import 'package:minichess/app/routes/app_pages.dart';
import '../../../data/enums.dart';
import '../../hallOfFame/views/hall_of_fame_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

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
              SizedBox(
                height: 200,
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
              ),
            ],
          ),
          Positioned(
            top: 4,
            right: 4,
            child: FloatingActionButton(
                child: const Icon(CupertinoIcons.person),
                onPressed: () => controller.showAuthDialog()),
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
                  // Get.to(TutorialView());
                }),
            const Text('Tutorial'),
          ],
        ),
      ),
    );
  }
}
