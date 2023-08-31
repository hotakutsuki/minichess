import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/gameObjects/tile.dart';
import '../../../utils/utils.dart';
import '../../../data/enums.dart';
import '../controllers/match_controller.dart';
import 'package:vector_math/vector_math_64.dart' as math;

import '../controllers/tile_controller.dart';

class ChessTile extends GetView {
  ChessTile({Key? key, required this.tile, this.playersTurn}) : super(key: key);

  final Tile tile;
  final player? playersTurn;
  MatchController matchController = Get.find<MatchController>();

  late final TileController tileController =
      Get.put(TileController(), tag: tile.toString());

  Color getTileColor() {
    if (tile.isSelected) {
      return Colors.blueGrey;
    } else {
      return Colors.transparent;
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
        onTap: () => matchController.onTapTile(tile),
        child: RotatedBox(
          quarterTurns: tile.owner == possession.mine ? 0 : 2,
          child: Container(
            decoration: BoxDecoration(
              image: tile.isOption
                  ? const DecorationImage(
                      image: AssetImage('assets/images/selected.png'),
                    )
                  : null,
            ),
            child: AnimatedBuilder(
              animation: tileController.animationController,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: getBase(
                        tile.owner == possession.none ? player.none :
                          getbool(tile.owner == possession.mine)
                              ? player.white
                              : player.black,
                          tile.isSelected),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: getCharAsset(
                          tile.char,
                          getbool(tile.owner == possession.mine)
                              ? player.white
                              : player.black,
                          tile.isSelected),
                    ),
                  ),
                ],
              ),
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  origin: const Offset(50, 50),
                  transform: Matrix4.compose(
                    tileController.translation *
                        tileController.animationController
                            .drive(CurveTween(curve: Curves.easeInOutQuint))
                            .value,
                    math.Quaternion.euler(
                        0,
                        0,
                        tileController.rotation *
                            tileController.animationController
                                .drive(CurveTween(curve: Curves.easeInOutQuint))
                                .value),
                    math.Vector3.all(tileController.iScale +
                        (tileController.fScale - tileController.iScale) *
                            tileController.animationController
                                .drive(CurveTween(curve: Curves.easeInOutQuint))
                                .value),
                  ),
                  child: child,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
