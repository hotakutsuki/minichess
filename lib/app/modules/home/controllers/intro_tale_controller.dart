import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroTaleController extends GetxController {
  final showTale = false.obs;
  var pageController = PageController(
    initialPage: 0,
  );

  final pages = <TalePage>[
    TalePage(title: 'page1', layers: [
      TaleLayer(
        asset: const Placeholder(
          color: Colors.green,
        ),
        ltrb: [10, 10, 10, 10],
        delay: 300,
        showing: false.obs,
      ),
      TaleLayer(
        asset: const Placeholder(
          color: Colors.green,
        ),
        ltrb: [50, 50, 200, 500],
        width: 100,
        height: 100,
        delay: 400,
        showing: false.obs,
      ),
      TaleLayer(
        asset: const Placeholder(
          color: Colors.green,
        ),
        ltrb: [200, 700, 50, 50],
        delay: 500,
        showing: false.obs,
      ),
      TaleLayer(
        asset: const Text( "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
          textAlign: TextAlign.center,),
        ltrb: [200, 50, 50, 0],
        delay: 600,
        showing: false.obs,
      ),
    ]),
    TalePage(title: 'page2', layers: [
      TaleLayer(
        asset: const Placeholder(
          color: Colors.red,
        ),
        ltrb: [10, 10, 10, 10],
        width: 100,
        height: 100,
        delay: 300,
        showing: false.obs,
      ),
      TaleLayer(
        asset: const Placeholder(
          color: Colors.red,
        ),
        ltrb: [50, 500, 100, 50],
        width: 100,
        height: 100,
        delay: 400,
        showing: false.obs,
      ),
      TaleLayer(
        asset: const Placeholder(
          color: Colors.red,
        ),
        ltrb: [200, 200, 200, 200],
        width: 100,
        height: 100,
        delay: 500,
        showing: false.obs,
      ),
      TaleLayer(
        asset: const Text(
            'Very long long texto for page 2, Very long long texto for page 2, Very long long texto for page 2'),
        ltrb: [300, 500, 50, 50],
        width: 100,
        height: 100,
        delay: 600,
        showing: false.obs,
      ),
    ]),
  ];

  void handleOnPageChange(int page) {
    //switch off all shows
    for (var page in pages) {
      for (var layer in page.layers) {
        layer.showing.value = false;
      }
    }
    //switch on shows for current page
    for (var layer in (pages[page].layers)) {
      Future.delayed(Duration(milliseconds: layer.delay), () {
        layer.showing.value = true;
      });
    }
  }

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(const Duration(milliseconds: 1000));

    for (var layer in (pages[0].layers)) {
      Future.delayed(Duration(milliseconds: layer.delay), () {
        layer.showing.value = true;
      });
    }
  }
}

class TalePage {
  final String title;
  final List<TaleLayer> layers;

  TalePage({
    required this.title,
    required this.layers,
  });
}

class TaleLayer {
  final Widget asset;
  final List<double> ltrb;
  final double? width;
  final double? height;
  final int delay;
  final Rx<bool> showing;

  TaleLayer({
    required this.asset,
    required this.ltrb,
    this.width,
    this.height,
    required this.delay,
    required this.showing,
  });
}
