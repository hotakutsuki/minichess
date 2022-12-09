import 'package:flutter/material.dart';
import 'package:minichess/widgets/ChessGame.dart';
import '../utils/Enums.dart';
import 'Tutorial.dart';

class HomeScreen extends StatelessWidget {
  setMode(context, gameMode mode) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ChessGame(gamemode: mode)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Minichess',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 200,
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () => setMode(context, gameMode.vs),
                      child: const Text(
                        '2 players',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () => setMode(context, gameMode.solo),
                      child: const Text(
                        'Vs PC',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () => setMode(context, gameMode.training),
                      child: const Text(
                        'training',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Tutorial()),
                        );
                      },
                      child: const Text(
                        'Tutorial',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
