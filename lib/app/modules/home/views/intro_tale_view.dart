import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../controllers/intro_tale_controller.dart';

class IntroTaleView extends GetView<IntroTaleController> {
  const IntroTaleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: Obx(() => Stack(children: [
              ...controller.pages
                  .map((page) =>
                  Stack(
                    children: page.layers
                        .map((layer) =>
                              AnimatedPositioned(
                                left: layer.ltrb[0],
                                top: layer.showing.value
                                    ? layer.ltrb[1]
                                    : -MediaQuery
                                    .of(context)
                                    .size
                                    .height,
                                right: layer.ltrb[2],
                                bottom: layer.showing.value
                                    ? layer.ltrb[3]
                                    : MediaQuery
                                    .of(context)
                                    .size
                                    .height,
                                curve: Curves.easeOutExpo,
                                duration: const Duration(milliseconds: 500),
                                child: layer.asset,
                              )).toList(),
                  )).toList(),
              PageView(
                onPageChanged: controller.handleOnPageChange,
                controller: controller.pageController,
                children: controller.pages
                    .map((page) => const Placeholder(color: Colors.transparent))
                    .toList(),
              ),
              Positioned(
                  right: 10,
                  top: 10,
                  child: FloatingActionButton(
                      heroTag: 'close',
                      onPressed: controller.hideTale,
                      child: const Icon(Icons.close, color: Colors.white60))),
            ])),
          ),
          SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton(
                      heroTag: 'previous',
                      onPressed: controller.handlePreviousPage,
                      child: const Icon(Icons.arrow_left)
                  ),
                  Obx(() => FloatingActionButton(
                        heroTag: 'next',
                        onPressed: controller.handleNextPage,
                        child: controller.disableNext.value ?
                        const Icon(Icons.close) : const Icon(Icons.arrow_right)
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
