import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inti_the_inka_chess_game/app/modules/match/views/match_view.dart';
import '../../../engine/rule_modifier.dart';
import '../../../engine/rules.dart';
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

  // The character to draw — may differ from tile.char when a modifier transforms
  // the piece's appearance (e.g. "todas se vuelven osos").
  chrt displayCharOf() {
    final gs = matchController.gs.value;
    return gs == null ? tile.char : effectiveChar(tile, gs);
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
                    displayCharOf(),
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
            if (tile.felledTurns > 0) _felledOverlay(),
            interactive,
            if (tile.isOption) _optionHint(),
            _witherBadge(),
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
        displayCharOf(),
        getbool(tile.owner == possession.mine) ? player.white : player.black,
        true,
      ),
    );
  }

  Widget _maybePulse(bool active, Widget child) =>
      active ? Pulse(child: child) : child;

  // A "felled" (inaccessible) square: darkened with a no-step mark.
  Widget _felledOverlay() => IgnorePointer(
        child: Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.brown.shade300, width: 2),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.do_not_step_outlined,
              color: Colors.white70, size: 26),
        ),
      );

  // Small badge counting down the turns until this piece withers ("Marchitar").
  Widget _witherBadge() {
    final gs = matchController.gs.value;
    if (gs == null || tile.char == chrt.empty || tile.char == chrt.king) {
      return const SizedBox.shrink();
    }
    for (final m in gs.modifiers) {
      if (m is WitherModifier && m.appliesTo(tile.owner, gs)) {
        final left = m.turns - tile.idleTurns;
        if (left <= 0) continue;
        return Positioned(
          top: 6,
          right: 6,
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Text('$left',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }

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
