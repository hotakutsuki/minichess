import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../utils/gameObjects/tile.dart';
import '../controllers/match_controller.dart';
import 'ChessTile.dart';

class ChessBoard extends GetView {
  ChessBoard(
      {Key? key,
        required this.matrix,
        // required this.onTapTile,
        this.playersTurn})
      : super(key: key);

  final List<List<Tile>> matrix;
  MatchController matchController = Get.find<MatchController>();
  final playersTurn;

  getTable() {
    var table = matrix.asMap().entries.map<TableRow>((row) {
      int i = row.key;
      return TableRow(
          children: row.value.asMap().entries.map<Widget>((v) {
            int j = v.key;
            return ChessTile(
              tile: matrix.reversed.toList()[i][j],
              playersTurn: playersTurn,
            );
          }).toList());
    }).toList();
    return table;
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black12),
      children: getTable(),
    );
  }
}