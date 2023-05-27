import 'dart:math';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../data/enums.dart';
import '../modules/match/controllers/ai_controller.dart';
import '../modules/match/controllers/tile_controller.dart';
import 'gameObjects/GameState.dart';
import 'gameObjects/move.dart';
import 'gameObjects/tile.dart';

createNewBoard() {
  var matrix = [
    [
      Tile(chrt.bishop, possession.mine, 0, 0),
      Tile(chrt.king, possession.mine, 1, 0),
      Tile(chrt.rock, possession.mine, 2, 0)
    ],
    [
      Tile(chrt.empty, possession.none, 0, 1),
      Tile(chrt.pawn, possession.mine, 1, 1),
      Tile(chrt.empty, possession.none, 2, 1)
    ],
    [
      Tile(chrt.empty, possession.none, 0, 2),
      Tile(chrt.pawn, possession.enemy, 1, 2),
      Tile(chrt.empty, possession.none, 2, 2)
    ],
    [
      Tile(chrt.rock, possession.enemy, 0, 3),
      Tile(chrt.king, possession.enemy, 1, 3),
      Tile(chrt.bishop, possession.enemy, 2, 3)
    ],
  ];

  // printMatrix(matrix);
  return matrix;
}

double getScale(BuildContext context){
  double h = MediaQuery.of(context).size.height / 700;
  double w = MediaQuery.of(context).size.width / 396;
  double minimun = min(h,w);
  return min(minimun,1);
}

Widget getImage(chrt char, player owner) {
  switch (char) {
    case chrt.pawn:
      return Image.asset(
        owner == player.white
            ? 'assets/images/pawnW.png'
            : 'assets/images/pawnB.png',
      );
    case chrt.knight:
      return Image.asset(
        owner == player.white
            ? 'assets/images/knightW.png'
            : 'assets/images/knightB.png',
      );
    case chrt.king:
      return Image.asset(
        owner == player.white
            ? 'assets/images/kingW.png'
            : 'assets/images/kingB.png',
      );
    case chrt.bishop:
      return Image.asset(
        owner == player.white
            ? 'assets/images/bishopW.png'
            : 'assets/images/bishopB.png',
      );
    case chrt.rock:
      return Image.asset(
        owner == player.white
            ? 'assets/images/rockW.png'
            : 'assets/images/rockB.png',
      );
    case chrt.queen:
      return Image.asset(
        owner == player.white
            ? 'assets/images/queenW.png'
            : 'assets/images/queenB.png',
      );
    case chrt.empty:
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

getRandomInt(int max, [min]) {
  var rnd = Random();
  return rnd.nextInt(max);
}

getRandomIntBetween(int min, int max) {
  var rnd = Random();
  return min + rnd.nextInt(max - min);
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

Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi;
}

bool hardSearchMove(Move move, GameState gs, bool hard) {
  if (hard) {
    return true;
  }
  GameState newGameState = GameState.clone(gs);
  newGameState.changeGameState(move);
  final aiController = Get.put(AiController());
  return !aiController.isInCheck(newGameState);
}

bool checkIfValidMove(Move m, GameState gs, [bool hard = false]) {
  if (isFromGraveyard(m.initialTile)) {
    return m.finalTile.char == chrt.empty;
  } else {
    if (m.initialTile.owner == m.finalTile.owner) {
      return false;
    } else {
      switch (m.initialTile.char) {
        case chrt.pawn:
        // print(selectedTile);
          if (m.initialTile.owner == possession.mine) {
            return m.initialTile.i! == m.finalTile.i &&
                m.initialTile.j == (m.finalTile.j! - 1);
          } else {
            return m.initialTile.i! == m.finalTile.i &&
                m.initialTile.j == (m.finalTile.j! + 1);
          }
        case chrt.king:
          return (m.initialTile.i! + 1 == m.finalTile.i &&
              m.initialTile.j! + 1 == m.finalTile.j &&
              hardSearchMove(m, gs, hard)) ||
              (m.initialTile.i! + 1 == m.finalTile.i &&
                  m.initialTile.j == m.finalTile.j &&
                  hardSearchMove(m, gs, hard)) ||
              (m.initialTile.i! + 1 == m.finalTile.i &&
                  m.initialTile.j! - 1 == m.finalTile.j &&
                  hardSearchMove(m, gs, hard)) ||
              (m.initialTile.i == m.finalTile.i &&
                  m.initialTile.j! + 1 == m.finalTile.j &&
                  hardSearchMove(m, gs, hard)) ||
              (m.initialTile.i == m.finalTile.i &&
                  m.initialTile.j! - 1 == m.finalTile.j &&
                  hardSearchMove(m, gs, hard)) ||
              (m.initialTile.i! - 1 == m.finalTile.i &&
                  m.initialTile.j! + 1 == m.finalTile.j &&
                  hardSearchMove(m, gs, hard)) ||
              (m.initialTile.i! - 1 == m.finalTile.i &&
                  m.initialTile.j == m.finalTile.j &&
                  hardSearchMove(m, gs, hard)) ||
              (m.initialTile.i! - 1 == m.finalTile.i &&
                  m.initialTile.j! - 1 == m.finalTile.j &&
                  hardSearchMove(m, gs, hard));
        case chrt.bishop:
          return (m.initialTile.i! + 1 == m.finalTile.i &&
              m.initialTile.j! + 1 == m.finalTile.j) ||
              (m.initialTile.i! + 1 == m.finalTile.i &&
                  m.initialTile.j! - 1 == m.finalTile.j) ||
              (m.initialTile.i! - 1 == m.finalTile.i &&
                  m.initialTile.j! + 1 == m.finalTile.j) ||
              (m.initialTile.i! - 1 == m.finalTile.i &&
                  m.initialTile.j! - 1 == m.finalTile.j);
        case chrt.rock:
          return (m.initialTile.i! + 1 == m.finalTile.i &&
              m.initialTile.j == m.finalTile.j) ||
              (m.initialTile.i == m.finalTile.i &&
                  m.initialTile.j! + 1 == m.finalTile.j) ||
              (m.initialTile.i == m.finalTile.i &&
                  m.initialTile.j! - 1 == m.finalTile.j) ||
              (m.initialTile.i! - 1 == m.finalTile.i &&
                  m.initialTile.j == m.finalTile.j);
        case chrt.knight:
          if (m.initialTile.owner == player.white) {
            return (m.initialTile.j! + 1 == m.finalTile.j &&
                m.initialTile.i == m.finalTile.i) ||
                (m.initialTile.j == m.finalTile.j &&
                    m.initialTile.i! + 1 == m.finalTile.i) ||
                (m.initialTile.j == m.finalTile.j &&
                    m.initialTile.i! - 1 == m.finalTile.i) ||
                (m.initialTile.j! - 1 == m.finalTile.j &&
                    m.initialTile.i == m.finalTile.i) ||
                (m.initialTile.j! - 1 == m.finalTile.j &&
                    m.initialTile.i! + 1 == m.finalTile.i) ||
                (m.initialTile.j! - 1 == m.finalTile.j &&
                    m.initialTile.i! - 1 == m.finalTile.i);
          } else {
            return (m.initialTile.j! + 1 == m.finalTile.j &&
                m.initialTile.i == m.finalTile.i) ||
                (m.initialTile.j == m.finalTile.j &&
                    m.initialTile.i! + 1 == m.finalTile.i) ||
                (m.initialTile.j == m.finalTile.j &&
                    m.initialTile.i! - 1 == m.finalTile.i) ||
                (m.initialTile.j! - 1 == m.finalTile.j &&
                    m.initialTile.i == m.finalTile.i) ||
                (m.initialTile.j! + 1 == m.finalTile.j &&
                    m.initialTile.i! + 1 == m.finalTile.i) ||
                (m.initialTile.j! + 1 == m.finalTile.j &&
                    m.initialTile.i! - 1 == m.finalTile.i);
          }
        case chrt.empty:
          return false;
        case chrt.queen:
          return false;
      }
    }
  }
}

bool checkIfWin(Move move) {
  return move.finalTile.char == chrt.king;
}