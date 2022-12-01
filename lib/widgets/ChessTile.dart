import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:minichess/utils/Enums.dart';
import '../doms/Tile.dart';
import '../utils/utils.dart';

class ChessTile extends StatelessWidget {
  const ChessTile(
      {Key? key, required this.tile, required this.onTapTile, this.playersTurn})
      : super(key: key);

  final Tile tile;
  final onTapTile;
  final playersTurn;

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
        onTap: () => onTapTile(tile),
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
              child: getImage(
                  tile.char,
                  getbool(tile.owner == possession.mine)
                      ? player.white
                      : player.black),
            ),
          ),
          Text('${tile.i}${tile.j}${tile.owner.name}'),
        ]),
      ),
    );
  }
}
