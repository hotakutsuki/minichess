import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inti_the_inka_chess_game/app/modules/match/views/match_view.dart';
import '../../../utils/gameObjects/tile.dart';
import '../../../utils/utils.dart';
import '../../../data/enums.dart';
import '../controllers/match_controller.dart';
import 'package:vector_math/vector_math_64.dart' as math;

import '../controllers/tile_controller.dart';
import '../views/clock_view.dart';
import 'pulse.dart';

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

  player getPlayer() {
    if (getbool(tile.owner == possession.mine)) {
      return player.white;
    }
    return player.black;
  }

  @override
  Widget build(BuildContext context) {
    final bool draggable =
        tile.char != chrt.empty && tile.owner == possession.mine;

    final Widget animatedPiece = AnimatedBuilder(
      animation: tileController.animationController,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child: getBase(
                  tile.owner == possession.none
                      ? player.none
                      : getbool(tile.owner == possession.mine)
                          ? player.white
                          : player.black,
                  tile.isSelected),
            ),
          ),
          Center(
            child: SizedBox(
              width: 75,
              height: 75,
              child: _maybePulse(
                tile.isSelected,
                getCharAsset(
                    tile.char,
                    getbool(tile.owner == possession.mine)
                        ? player.white
                        : player.black,
                    tile.isSelected),
              ),
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
    );

    final Widget interactive = InkWell(
      onTap: () => matchController.onTapTile(tile),
      child: RotatedBox(
        quarterTurns: tile.owner == possession.mine ? 0 : 2,
        child: draggable
            ? Draggable<Tile>(
                data: tile,
                onDragStarted: () => matchController.selectForDrag(tile),
                onDraggableCanceled: (_, __) =>
                    matchController.cancelSelection(),
                feedback: _dragFeedback(),
                childWhenDragging: Opacity(opacity: 0.25, child: animatedPiece),
                child: animatedPiece,
              )
            : animatedPiece,
      ),
    );

    return DragTarget<Tile>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (d) => matchController.onDragDrop(d.data, tile),
      builder: (context, candidate, rejected) => SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            interactive,
            if (tile.isOption) _optionHint(),
            _flashOverlay(),
          ],
        ),
      ),
    );
  }

  // The piece image that follows the finger while dragging.
  Widget _dragFeedback() {
    return SizedBox(
      width: 90,
      height: 90,
      child: getCharAsset(
        tile.char,
        getbool(tile.owner == possession.mine) ? player.white : player.black,
        true,
      ),
    );
  }

  Widget _maybePulse(bool active, Widget child) =>
      active ? Pulse(child: child) : child;

  // A pulsing hint on a reachable tile: a hollow ring around a capturable
  // piece, or a small dot on an empty square.
  Widget _optionHint() {
    final bool isCapture = tile.char != chrt.empty;
    return IgnorePointer(
      child: Pulse(
        min: 0.85,
        max: 1.05,
        child: isCapture
            ? Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.amberAccent.withOpacity(0.85), width: 3),
                ),
              )
            : Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
      ),
    );
  }

  // Gold flash that fades in/out when this tile's piece is captured.
  Widget _flashOverlay() => IgnorePointer(
        child: AnimatedBuilder(
          animation: tileController.flashController,
          builder: (BuildContext context, Widget? _) {
            final double v = tileController.flashController.value;
            if (v == 0) return const SizedBox.shrink();
            final double opacity = (sin(v * pi) * 0.8).clamp(0.0, 1.0);
            return Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD54F).withOpacity(opacity),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFCA28)
                        .withOpacity((opacity * 0.8).clamp(0.0, 1.0)),
                    blurRadius: 24,
                    spreadRadius: 8,
                  ),
                ],
              ),
            );
          },
        ),
      );
}
