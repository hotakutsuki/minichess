import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController animController =
      AnimationController(vsync: this, duration: const Duration(seconds: 180))..repeat(reverse: true);

  Widget backGround(context) {
    if (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width){
      return AnimatedBuilder(
        animation: animController,
        builder: (_, child) {
          return Transform.translate(
            offset: Offset(-30 + animController.value * (MediaQuery.of(context).size.width - MediaQuery.of(context).size.height + 60), 0),
            child: child,
          );
        },
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [Image.asset(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height,
              'assets/images/backgrounds/bg.jpg',
              fit: BoxFit.cover,
            )],
          ),
        ),
      );
    }
    return SizedBox.expand(
      child: Image.asset(
        'assets/images/backgrounds/bg.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}
