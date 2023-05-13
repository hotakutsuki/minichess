import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../utils/gameObjects/tile.dart';
import '../../../utils/utils.dart';
import '../../../data/enums.dart';
import '../controllers/match_controller.dart';
import '../controllers/tile_controller.dart';

class ChessTile extends GetView {
  ChessTile(
      {Key? key, required this.tile, this.playersTurn})
      : super(key: key);

  final Tile tile;
  // final onTapTile;
  final player? playersTurn;
  MatchController matchController = Get.find<MatchController>();

  late final TileController tileController = Get.put(
      TileController(), tag: '${tile.i}${tile.j}');

  Color getTileColor() {
    if (tile.isSelected) {
      return Colors.blueGrey;
    } else {
      return getbool((tile.i! + tile.j!) % 2 == 0)
          ? Colors.brown
          : const Color.fromARGB(255, 253, 238, 187);
    }
  }

  bool getbool(bool) {
    if (playersTurn == player.white) {
      return bool;
    } else {
      return !bool;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: InkWell(
        onTap: () => matchController.onTapTile(tile, tileController),
        child: Stack(children: [
          RotatedBox(
            quarterTurns: tile.owner == possession.mine ? 0 : 2,
            child: Container(
              decoration: BoxDecoration(
                  gradient: RadialGradient(colors: [
                    tile.isOption ? Colors.blueGrey : getTileColor(),
                    getTileColor(),
                    getTileColor()
                  ])),
              padding: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: tileController.animationController,
                child: getImage(
                    tile.char,
                    getbool(tile.owner == possession.mine)
                        ? player.white
                        : player.black),
                builder: (BuildContext context, Widget? child) {
                  return Transform.translate(
                      offset: Offset(
                          tileController.x * 100 * tileController.animationController.drive(CurveTween(curve: Curves.easeOutExpo)).value,
                          tileController.y * 100 * tileController.animationController.drive(CurveTween(curve: Curves.easeOutExpo)).value
                      ),
                      child: child,
                  );
                },
              ),
            ),
          ),
          // Text('${tile.i}${tile.j}${tile.owner.name}'),
        ]),
      ),
    );
  }
}