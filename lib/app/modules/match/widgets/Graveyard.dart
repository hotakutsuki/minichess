import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:minichess/app/modules/match/controllers/match_controller.dart';

import '../../../data/enums.dart';
import '../../../utils/gameObjects/tile.dart';
import '../../../utils/utils.dart';

class Graveyard extends GetView {
  Graveyard({Key? key, required this.p}) : super(key: key);

  // final List<Tile> graveyard;
  final player p;

  // final onTapTile;
  MatchController matchController = Get.find<MatchController>();

  List<Tile> getGraveyard() {
    if (p == player.black) {
      return (matchController.playersTurn == player.white
          ? matchController.gs.value.enemyGraveyard
          : matchController.gs.value.myGraveyard) as List<Tile>;
    }
    if (p == player.white) {
      return (matchController.playersTurn == player.white
          ? matchController.gs.value.myGraveyard
          : matchController.gs.value.enemyGraveyard) as List<Tile>;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 75,
      child: RotatedBox(
        quarterTurns: p == player.white ? 0 : 2,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: (getGraveyard())
              .map(
                (g) => SizedBox(
                  width: 100,
                  height: 100,
                  child: InkWell(
                    onTap: () => matchController.onTapTile(g),
                    child: Container(
                        padding: const EdgeInsets.all(16.0),
                        color:
                            g.isSelected ? Colors.blueGrey : Colors.transparent,
                        alignment: Alignment.center,
                        child: getImage(g.char, p)),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
