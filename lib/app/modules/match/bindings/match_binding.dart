import 'package:get/get.dart';

import 'package:minichess/app/modules/match/controllers/ai_controller.dart';
import 'package:minichess/app/modules/match/controllers/clock_controller.dart';
import 'package:minichess/app/modules/match/controllers/gameover_controller.dart';
import 'package:minichess/app/modules/match/controllers/match_making_controller.dart';

import '../../../services/database.dart';
import '../controllers/match_controller.dart';

class MatchBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<DatabaseController>(
    //   () => DatabaseController(),
    // );
    // Get.lazyPut<MatchMakingController>(
    //   () => MatchMakingController(),
    // );
    Get.lazyPut<GameoverController>(
      () => GameoverController(),
    );
    Get.lazyPut<AiController>(
      () => AiController(),
    );
    Get.lazyPut<ClockController>(
      () => ClockController(),
    );
    Get.lazyPut<MatchController>(
      () => MatchController(),
    );
  }
}
