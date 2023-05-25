import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:minichess/app/modules/match/controllers/match_controller.dart';
import 'package:minichess/app/modules/match/widgets/GraveyardTile.dart';

import '../../../data/enums.dart';
import '../../../utils/gameObjects/tile.dart';
import '../controllers/GraveyardController.dart';

class Graveyard extends GetView {
  Graveyard({Key? key, required this.p}) : super(key: key);

  final player p;
  late final GraveyardController gyController =
      Get.put(GraveyardController(), tag: p.name);
  MatchController matchController = Get.find<MatchController>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: gyController.animationController,
      child: RotatedBox(
        quarterTurns: p == player.white ? 0 : 2,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey, width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: (gyController.getGraveyard(p))
                .map((g) => GraveyardTile(
                      matchController: matchController,
                      tile: g,
                      p: p,
                    ))
                .toList(),
          ),
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return SizedBox(
          width: 360,
          height: 60,
          child: Stack(
            children: [
              child!,
              Transform.scale(
                scaleY: gyController.animationController.value,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
