import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums.dart';
import '../controllers/GraveyardController.dart';
import '../controllers/match_controller.dart';
import 'GraveyardTile.dart';

class Graveyard extends GetView {
  Graveyard({Key? key, required this.p}) : super(key: key);

  final player p;
  late final GraveyardController gyController =
  Get.put(GraveyardController(), tag: p.name);
  MatchController matchController = Get.find<MatchController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: SizedBox(
              width: graveyardTileWide,
              height: graveyardHeight,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: gyController.animationController,
          child: RotatedBox(
            quarterTurns: p == player.white ? 0 : 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: brackgroundColor, width: 1.0),
                color: brackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: (gyController.getGraveyard(p))
                    .map((g) => GraveyardTile(
                  matchController: matchController,
                  tile: g,
                  p: p,
                )).toList(),
              ),
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return SizedBox(
              width: graveyardTileWide,
              height: graveyardHeight,
              child: Stack(
                children: [
                  child!,
                  Center(
                    child: Transform.scale(
                      scaleY: gyController.animationController.value,
                      child: Container(
                        width: graveyardTileWide - 4,
                        height: graveyardHeight - 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: brackgroundColorSolid,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
