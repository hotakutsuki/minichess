import 'dart:math';
import 'package:flutter/material.dart';
import 'package:minichess/utils/Enums.dart';
import '../doms/Tile.dart';

createNewBoard() {
  var matrix = [
    [
      Tile(character.rock, player.black, 0, 0),
      Tile(character.king, player.black, 0, 1),
      Tile(character.bishop, player.black, 0, 2)
    ],
    [
      Tile(character.empty, player.none, 1, 0),
      Tile(character.pawn, player.black, 1, 1),
      Tile(character.empty, player.none, 1, 2)
    ],
    [
      Tile(character.empty, player.none, 2, 0),
      Tile(character.pawn, player.white, 2, 1),
      Tile(character.empty, player.none, 2, 2)
    ],
    [
      Tile(character.bishop, player.white, 3, 0),
      Tile(character.king, player.white, 3, 1),
      Tile(character.rock, player.white, 3, 2)
    ]
  ];

  // printMatrix(matrix);
  return matrix;
}

Widget getImage(character char, player owner) {
  switch (char) {
    case character.pawn:
      return Image.asset(owner == player.white ? 'assets/images/pawnW.png' : 'assets/images/pawnB.png',
        // color: geChartColor(owner),
      );
    case character.knight:
      return Image.asset(owner == player.white ? 'assets/images/knightW.png' : 'assets/images/knightB.png',
        // color: geChartColor(owner),
      );
    case character.king:
      return Image.asset(owner == player.white ? 'assets/images/kingW.png' : 'assets/images/kingB.png',
        // color: geChartColor(owner),
      );
    case character.bishop:
      return Image.asset(owner == player.white ? 'assets/images/bishopW.png' : 'assets/images/bishopB.png',
        // color: geChartColor(owner),
      );
    case character.rock:
      return Image.asset(owner == player.white ? 'assets/images/rockW.png' : 'assets/images/rockB.png',
        // color: geChartColor(owner),
      );
    case character.queen:
      return Image.asset(owner == player.white ? 'assets/images/queenW.png' : 'assets/images/queenB.png',
        // color: geChartColor(owner),
      );
    case character.empty:
      return const SizedBox.expand();
  }
}

Color geChartColor(player owner) {
  return owner == player.white ? Colors.white : Colors.black;
}

getRandomIO() {
  var rnd = Random();
  return rnd.nextInt(2);
}

void printMatrix(var matrix) {
  print('matrix:');
  for (var row in matrix) {
    String sRow = '';
    for (var v in row) {
      String s = v.char == ''
          ? "\x1B[32m${v.isOption}\x1B[0m"
          : "\x1B[36m${v.isOption}\x1B[0m";
      sRow = sRow + s;
    }
    print(sRow);
  }
}

int getNumberOfIsland(var matrix) {
  int numberOfIslands = 0;

  var booleanMatrix = List.generate(
    matrix.length,
    (i) => List.generate(matrix.length, (i) => 0),
  );
  for (int j = 0; j < matrix.length; j++) {
    for (int i = 0; i < matrix[j].length; i++) {
      if (matrix[j][i] == 1 && booleanMatrix[j][i] == 0) {
        //new island
        numberOfIslands++;
        booleanMatrix = setIslandInTrue(i, j, booleanMatrix, matrix);
      }
    }
  }
  print('number of islands: ' + numberOfIslands.toString());
  return numberOfIslands;
}

setIslandInTrue(i, j, matrix, orgMatrix) {
  matrix[j][i] = 1;
  if (i + 1 < matrix.length &&
      matrix[j][i + 1] != 1 &&
      orgMatrix[j][i + 1] == 1) {
    matrix = setIslandInTrue(i + 1, j, matrix, orgMatrix);
  }
  if (i - 1 >= 0 && matrix[j][i - 1] != 1 && orgMatrix[j][i - 1] == 1) {
    matrix = setIslandInTrue(i - 1, j, matrix, orgMatrix);
  }
  if (j + 1 < matrix[i].length &&
      matrix[j + 1][i] != 1 &&
      orgMatrix[j + 1][i] == 1) {
    matrix = setIslandInTrue(i, j + 1, matrix, orgMatrix);
  }
  if (j - 1 >= 0 && matrix[j - 1][i] != 1 && orgMatrix[j - 1][i] == 1) {
    matrix = setIslandInTrue(i, j - 1, matrix, orgMatrix);
  }
  return matrix;
}