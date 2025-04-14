import 'package:get/get.dart';

import '../controllers/GraveyardController.dart';
import '../controllers/ai_controller.dart';
import '../controllers/clock_controller.dart';
import '../controllers/gameover_controller.dart';
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
    Get.lazyPut<GraveyardController>(
          () => GraveyardController(),
    );
  }
}
