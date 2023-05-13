import 'package:get/get.dart';

import 'package:minichess/app/modules/match/controllers/ai_controller.dart';
import 'package:minichess/app/modules/match/controllers/clock_controller.dart';
import 'package:minichess/app/modules/match/controllers/gameover_controller.dart';

import '../controllers/match_controller.dart';
import '../controllers/tile_controller.dart';

class MatchBinding extends Bindings {
  @override
  void dependencies() {
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
    Get.lazyPut<TileController>(
      () => TileController(),
    );
  }
}
