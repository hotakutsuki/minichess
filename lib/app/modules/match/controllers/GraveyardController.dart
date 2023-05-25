import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/enums.dart';

import '../../../utils/gameObjects/tile.dart';
import 'match_controller.dart';

class GraveyardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  MatchController matchController = Get.find<MatchController>();

  List<Tile> getGraveyard(p) {
    if (p == player.black) {
      return (matchController.playersTurn == player.white
          ? matchController.gs.value!.enemyGraveyard
          : matchController.gs.value!.myGraveyard);
    }
    if (p == player.white) {
      return (matchController.playersTurn == player.white
          ? matchController.gs.value!.myGraveyard
          : matchController.gs.value!.enemyGraveyard);
    }
    return [];
  }

  animateGraveyard() async {
    await animationController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    await animationController.reverse();
    animationController.reset();
  }

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
