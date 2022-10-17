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
      );
    case character.knight:
      return Image.asset(owner == player.white ? 'assets/images/knightW.png' : 'assets/images/knightB.png',
      );
    case character.king:
      return Image.asset(owner == player.white ? 'assets/images/kingW.png' : 'assets/images/kingB.png',
      );
    case character.bishop:
      return Image.asset(owner == player.white ? 'assets/images/bishopW.png' : 'assets/images/bishopB.png',
      );
    case character.rock:
      return Image.asset(owner == player.white ? 'assets/images/rockW.png' : 'assets/images/rockB.png',
      );
    case character.queen:
      return Image.asset(owner == player.white ? 'assets/images/queenW.png' : 'assets/images/queenB.png',
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

getRandomInt(int max) {
  var rnd = Random();
  return rnd.nextInt(max);
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

bool isFromGraveyard(Tile tile) {
  return tile.i == null;
}

bool checkIfValidPosition(Tile tile, Tile? selectedTile) {
  if (selectedTile == null) {
    return false;
  } else if (isFromGraveyard(selectedTile)) {
    return tile.char == character.empty;
  } else {
    if (selectedTile.owner == tile.owner) {
      return false;
    } else {
      switch (selectedTile.char) {
        case character.pawn:
          if (selectedTile.owner == player.white) {
            return selectedTile.i! - 1 == tile.i && selectedTile.j == tile.j;
          } else {
            return selectedTile.i! + 1 == tile.i && selectedTile.j == tile.j;
          }
        case character.king:
          return (selectedTile.i! + 1 == tile.i &&
              selectedTile.j! + 1 == tile.j) ||
              (selectedTile.i! + 1 == tile.i && selectedTile.j == tile.j) ||
              (selectedTile.i! + 1 == tile.i &&
                  selectedTile.j! - 1 == tile.j) ||
              (selectedTile.i == tile.i && selectedTile.j! + 1 == tile.j) ||
              (selectedTile.i == tile.i && selectedTile.j! - 1 == tile.j) ||
              (selectedTile.i! - 1 == tile.i &&
                  selectedTile.j! + 1 == tile.j) ||
              (selectedTile.i! - 1 == tile.i && selectedTile.j == tile.j) ||
              (selectedTile.i! - 1 == tile.i && selectedTile.j! - 1 == tile.j);
        case character.bishop:
          return (selectedTile.i! + 1 == tile.i &&
              selectedTile.j! + 1 == tile.j) ||
              (selectedTile.i! + 1 == tile.i &&
                  selectedTile.j! - 1 == tile.j) ||
              (selectedTile.i! - 1 == tile.i &&
                  selectedTile.j! + 1 == tile.j) ||
              (selectedTile.i! - 1 == tile.i && selectedTile.j! - 1 == tile.j);
        case character.rock:
          return (selectedTile.i! + 1 == tile.i && selectedTile.j == tile.j) ||
              (selectedTile.i == tile.i && selectedTile.j! + 1 == tile.j) ||
              (selectedTile.i == tile.i && selectedTile.j! - 1 == tile.j) ||
              (selectedTile.i! - 1 == tile.i && selectedTile.j == tile.j);
        case character.knight:
          if (selectedTile.owner == player.white) {
            return (selectedTile.i! + 1 == tile.i &&
                selectedTile.j == tile.j) ||
                (selectedTile.i == tile.i && selectedTile.j! + 1 == tile.j) ||
                (selectedTile.i == tile.i && selectedTile.j! - 1 == tile.j) ||
                (selectedTile.i! - 1 == tile.i && selectedTile.j == tile.j) ||
                (selectedTile.i! - 1 == tile.i &&
                    selectedTile.j! + 1 == tile.j) ||
                (selectedTile.i! - 1 == tile.i &&
                    selectedTile.j! - 1 == tile.j);
          } else {
            return (selectedTile.i! + 1 == tile.i &&
                selectedTile.j == tile.j) ||
                (selectedTile.i == tile.i && selectedTile.j! + 1 == tile.j) ||
                (selectedTile.i == tile.i && selectedTile.j! - 1 == tile.j) ||
                (selectedTile.i! - 1 == tile.i && selectedTile.j == tile.j) ||
                (selectedTile.i! + 1 == tile.i &&
                    selectedTile.j! + 1 == tile.j) ||
                (selectedTile.i! + 1 == tile.i &&
                    selectedTile.j! - 1 == tile.j);
          }
        case character.empty:
          return false;
        case character.queen:
          return false;
      }
    }
  }
}

// void sleep(Duration duration) {
//   int milliseconds = duration.inMilliseconds;
//   if (milliseconds < 0) {
//     throw ArgumentError("sleep: duration cannot be negative");
//   }
//   if (!_EmbedderConfig._maySleep) {
//     throw new UnsupportedError(
//         "This embedder disallows calling dart:io's sleep()");
//   }
//   _ProcessUtils._sleep(milliseconds);
// }