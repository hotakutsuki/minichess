import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:minichess/utils/Enums.dart';
import '../doms/Tile.dart';
import '../utils/utils.dart';

class ChessTile extends StatelessWidget {
  const ChessTile({Key? key, required this.tile, required this.onTapTile})
      : super(key: key);

  final Tile tile;
  final onTapTile;

  Color getTileColor() {
    if (tile.isSelected) {
      return Colors.blueGrey;
    } else {
      return (tile.i! + tile.j!) % 2 == 0
          ? Colors.brown
          : const Color.fromARGB(255, 253, 238, 187);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(children: [
        InkWell(
          onTap: () => onTapTile(tile),
          child: RotatedBox(
            quarterTurns: tile.owner == player.white ? 0 : 2,
            child: Container(
              decoration: BoxDecoration(
                  gradient: RadialGradient(colors: [
                tile.isOption ? Colors.blueGrey : getTileColor(),
                getTileColor(),
                getTileColor()
              ])),
              padding: const EdgeInsets.all(4.0),
              // color: getTileColor(),
              alignment: Alignment.center,
              child: getImage(tile.char, tile.owner),
            ),
          ),
        ),
        Text('${tile.char.name[0]}${tile.char.name[1]}'
            '${tile.owner == player.none ? 'n' : tile.owner.name[0]}'),
      ]),
    );
  }
}
