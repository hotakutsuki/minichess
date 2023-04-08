import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../utils/gameObjects/tile.dart';
import 'ChessTile.dart';

class ChessBoard extends GetView {
  const ChessBoard(
      {Key? key,
        required this.matrix,
        // required this.onTapTile,
        this.playersTurn})
      : super(key: key);

  final List<List<Tile>> matrix;
  // final onTapTile;
  final playersTurn;

  getTable() {
    var table = matrix.asMap().entries.map<TableRow>((row) {
      int i = row.key;
      return TableRow(
          children: row.value.asMap().entries.map<Widget>((v) {
            int j = v.key;
            return ChessTile(
              tile: matrix.reversed.toList()[i][j],
              // onTapTile: onTapTile,
              playersTurn: playersTurn,
            );
          }).toList());
    }).toList();
    return table;
  }

  @override
  Widget build(BuildContext context) {
    return (matrix == null
        ? const Placeholder()
        : SizedBox(
      width: 300,
      height: 400,
      child: Table(
        border: TableBorder.all(color: Colors.black12),
        children: getTable(),
      ),
    ));
  }
}