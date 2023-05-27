import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vector_math/vector_math_64.dart';

class TileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  Vector3 translation = Vector3.zero();
  double iScale = 1;
  double fScale = 1;
  double rotation = 0;

  animateTile(int? ii, int? ij, [int? fi, int? fj, int? gyPosition]) async {
    if (ii == null && ij == null) {//from graveyard
      translation =
          Vector3(48 + (-gyPosition! * 60) + fi! * 100, -95 - fj! * 100, 0);
      iScale = 1;
      fScale = 1.8;
    } else if (fi != null && fj != null) {//normal translation
      translation = Vector3((fi - ii!) * 100, (ij! - fj) * 100, 0);
    } else if (fi == null && fj == null) {//to graveyard
      translation =
          Vector3(ii! * 100 + 48 + (gyPosition ?? 0) * -60, ij! * 100 + 5, 0);
      iScale = 1;
      fScale = .6;
      rotation = pi;
    }
    update();
    await animationController.forward();
    resetAnimations();
  }

  resetAnimations() {
    translation = Vector3.zero();
    iScale = 1;
    fScale = 1;
    rotation = 0;
    update();
    animationController.reset();
  }

  @override
  void onInit() {
    print('Initing tile controller');
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
