import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import '../../../data/enums.dart';
import '../../../utils/gameObjects/tile.dart';
import '../controllers/match_controller.dart';
import '../../../utils/utils.dart';
import '../controllers/tile_controller.dart';



class GraveyardTile extends GetView {
  GraveyardTile(
      {Key? key,
      required this.matchController,
      required this.tile,
      required this.p})
      : super(key: key);

  final MatchController matchController;
  final Tile tile;
  final player p;

  late final TileController tileController =
      Get.put(TileController(), tag: tile.toString());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => matchController.onTapTile(tile),
      child: Container(
          width: 60,
          color: tile.isSelected ? Colors.blueGrey : Colors.transparent,
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: tileController.animationController,
            child: getImage(tile.char, p),
            builder: (context, child) {
              return Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Transform(
                    origin: const Offset(25, 25),
                    transform: Matrix4.compose(
                      tileController.translation * tileController.animationController
                          .drive(CurveTween(curve: Curves.easeOutExpo))
                          .value,
                      math.Quaternion.euler(0, 0,
                          tileController.rotation * tileController.animationController
                              .drive(CurveTween(curve: Curves.easeOutExpo))
                              .value),
                      math.Vector3.all(tileController.iScale +
                          (tileController.fScale - tileController.iScale) * tileController.animationController
                              .drive(CurveTween(curve: Curves.easeOutExpo))
                              .value
                      ),
                    ),
                    child: child,
                  ),
                ),
              );
            },
          )),
    );
  }
}
