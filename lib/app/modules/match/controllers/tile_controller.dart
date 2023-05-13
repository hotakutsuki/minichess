import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../../utils/gameObjects/tile.dart';

class TileController extends GetxController with GetSingleTickerProviderStateMixin{

  late AnimationController animationController;
  int x = 1;
  int y = 1;
  RxInt z = 1.obs;
  animateTile(int i, int j) async {
    x = i;
    y = j;
    update();
    await animationController.forward();
    animationController.reset();
    z.value = 1;
  }

  @override
  void onInit() {
    print('Initing tile controller');
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
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
