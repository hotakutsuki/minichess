import 'package:flutter/material.dart';
import '../utils/Enums.dart';
import '../utils/utils.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen(
      this.winner, this.restartGame, this.wScore, this.bScore, this.gamemode,
      {super.key});

  final player winner;
  final VoidCallback restartGame;
  final int wScore, bScore;
  final gameMode gamemode;

  Color getTextColor() {
    return winner == player.white ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: winner == player.white
          ? const Color.fromARGB(225, 255, 255, 255)
          : const Color.fromARGB(225, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Winner: ${winner == player.white ? 'White' : 'Black'}',
              style: TextStyle(
                  color: getTextColor(),
                  fontSize: 48,
                  fontWeight: FontWeight.bold)),
          SizedBox(
              width: 250, height: 250, child: getImage(chrt.queen, winner)),
          Text(
            gamemode != gameMode.solo ? '' : 'W   B\n$wScore - $bScore',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: getTextColor(),
                fontSize: 42,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 40,
            width: 150,
            child: ElevatedButton(
              onPressed: restartGame,
              child: const Text(
                'Restart',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
