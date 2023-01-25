import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../doms/Tile.dart';
import '../utils/Enums.dart';
import '../utils/Utils.dart';

class Graveyard extends StatelessWidget{
  const Graveyard({Key? key, required this.graveyard, required this.p, this.onTapTile})
      : super(key: key);

  final List<Tile> graveyard;
  final player p;
  final onTapTile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 75,
      child: RotatedBox(
        quarterTurns:  p == player.white ? 0 : 2,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: graveyard.map(
              (g) => SizedBox(
            width: 100,
            height: 100,
            child: InkWell(
              onTap: () => onTapTile(g),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: g.isSelected ? Colors.blueGrey : Colors.transparent,
                alignment: Alignment.center,
                child: getImage(g.char, p)
              ),
            ),
          ),
          ).toList(),
        ),
      ),
    );
  }
}