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
        color: Colors.black,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [...controller.pages.map((page) => Stack(
          children: page.layers.map((layer) => Obx(
            () => AnimatedPositioned(
              left: layer.ltrb[0],
              top: layer.showing.value ? layer.ltrb[1] : -MediaQuery.of(context).size.height,
              right: layer.ltrb[2],
              bottom: layer.showing.value ? layer.ltrb[3] : MediaQuery.of(context).size.height,
              curve: Curves.easeOutExpo,
              duration: const Duration(milliseconds: 500),
              child: layer.asset,
            ),
          )).toList(),
        )).toList(),
          PageView(
            onPageChanged: controller.handleOnPageChange,
            controller: controller.pageController,
            children: controller.pages.map((page) => const Placeholder(color: Colors.grey)).toList(),
          )
        ]
      ),
    );
  }
}

