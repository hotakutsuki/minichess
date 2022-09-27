import 'package:flutter/material.dart';
import 'ChessTile.dart';

class ChessBoard extends StatelessWidget {
  const ChessBoard({Key? key, required this.matrix, required this.onTapTile}) : super(key: key);

  final matrix;
  final onTapTile;

  getTable() {
    var table = matrix.asMap().entries.map<TableRow>((row) {
      int i = row.key;
      return TableRow(
          children: row.value.asMap().entries.map<Widget>((v) {
        int j = v.key;
        return ChessTile(tile: matrix[i][j], onTapTile: onTapTile);
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
