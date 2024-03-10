import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../language/controllers/language_controller.dart';
import '../controllers/intro_tale_controller.dart';

class IntroTaleView extends GetView<IntroTaleController> {
  IntroTaleView({super.key});

  LanguageController l = Get.find<LanguageController>();

  Offset getOffset(int layer) {
    return Offset(
        (-5 + controller.aController.value * 10) * (layer + 1) * 2
        , 0
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Column(
          children: [
            Expanded(
              child: Obx(() =>
                  Stack(children: [
                    ...controller.pages
                        .map((page) =>
                        Stack(
                          children: [
                            ...page.layers
                                .asMap()
                                .entries
                                .map((e) {
                              var index = e.key;
                              var layer = e.value;
                              return AnimatedPositioned(
                                // left: index == 0 ? -200 : 0, // background goes beyond boundaries
                                // right: index == 0 ? -200 : 0, // background goes beyond boundaries
                                  left: -200,
                                  // background goes beyond boundaries
                                  right: -200,
                                  // background goes beyond boundaries
                                  top: layer.showing.value
                                      ? 0
                                      : -MediaQuery
                                      .of(context)
                                      .size
                                      .height,
                                  bottom: layer.showing.value
                                      ? 0
                                      : MediaQuery
                                      .of(context)
                                      .size
                                      .height,
                                  curve: Curves.easeOutExpo,
                                  duration: const Duration(milliseconds: 500),
                                  child: AnimatedBuilder(
                                    animation: controller.aController,
                                    //parallax
                                    builder: (_, child) {
                                      return Transform.translate(
                                        offset: getOffset(index),
                                        child: child,
                                      );
                                    },
                                    child: Center(
                                      child: index == 0
                                          ? layer.asset
                                          : Transform.translate(
                                        offset: Offset(
                                            layer.hwxy[2], layer.hwxy[3]),
                                        child: SizedBox(
                                          // height: layer.hwxy[0],
                                          // width: layer.hwxy[1],
                                            child: layer.asset),
                                      ),
                                    ),
                                  ));
                            }).toList(),
                            AnimatedPositioned(
                              left: page.layers[0].showing.value
                                  ? 0
                                  : MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              right: page.layers[0].showing.value
                                  ? 0
                                  : MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              bottom: 0,
                              curve: Curves.easeOutExpo,
                              duration: const Duration(milliseconds: 500),
                              child: Center(
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      boxShadow: [BoxShadow(
                                        color: Colors.black87,
                                        blurRadius: 10.0,
                                      )
                                      ],
                                    ),
                                    child: FittedBox(child: Obx(() {
                                      return Text(l.g(page.text),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700));
                                    }))),
                              ),
                            ),
                          ],
                        ))
                        .toList(),
                    PageView(
                      onPageChanged: controller.handleOnPageChange,
                      controller: controller.pageController,
                      children: controller.pages
                          .map((page) =>
                      const Placeholder(color: Colors.transparent))
                          .toList(),
                    ),
                    Positioned(
                        right: 10,
                        top: 10,
                        child: FloatingActionButton(
                            heroTag: 'close',
                            onPressed: controller.hideTale,
                            child: const Icon(Icons.close,
                                color: Colors.white60))),
                  ])),
            ),
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                        heroTag: 'previous',
                        onPressed: controller.handlePreviousPage,
                        child: const Icon(Icons.arrow_left)),
                    Obx(() =>
                        FloatingActionButton(
                            heroTag: 'next',
                            onPressed: controller.handleNextPage,
                            child: controller.disableNext.value
                                ? const Icon(Icons.close)
                                : const Icon(Icons.arrow_right))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
