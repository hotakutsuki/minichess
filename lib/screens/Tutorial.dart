import 'package:flutter/material.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({super.key});

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  final controller = PageController(
    initialPage: 0,
  );

  bool diablePrev = false, disableNext = false;

  @override
  void initState() {
    controller.addListener(() {
      diablePrev = controller.page == 0;
      disableNext = controller.page == 8;
    });
    super.initState();
  }

  Widget getPage(String image, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 500,
          padding: const EdgeInsets.all(48.0),
          child: Image.asset('assets/images/$image.png'),
        ),
        Padding(
          padding: const EdgeInsets.all(48.0),
          child: Text(text,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial'),
      ),
      body: Row(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: FloatingActionButton(
                backgroundColor: diablePrev ? Colors.grey : Colors.deepPurple,
                  heroTag: 'back',
                  mini: true,
                  child: const Icon(Icons.arrow_left),
                  onPressed: () {
                    controller.previousPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease);
                  }),
            ),
          ),
          Expanded(
            child: PageView(
              controller: controller,
              children: [
                getPage('1select', 'Tap on a tile to select it.'),
                getPage(
                    '2move', 'Tap on any of the highlighted tiles to move.'),
                getPage('3takepng', 'Tap on an enemy tile to take it.'),
                getPage('4grave',
                    'When a piece is taken, it goes to you graveyard.'),
                getPage(
                    '5revive', 'You can invoke pieces from your graveyard.'),
                getPage('6knigthpng',
                    'Reach to the top to transform a Pawn into a Knight.'),
                getPage('7win', 'Take the king to win.'),
                getPage('8clock',
                    'But watch out your clock. If it gets to 0, you lose.'),
                getPage('9moves', 'These are the valid moves.'),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: FloatingActionButton(
                  backgroundColor: disableNext ? Colors.grey : Colors.deepPurple,
                  heroTag: 'forward',
                  mini: true,
                  child: const Icon(Icons.arrow_right),
                  onPressed: () {
                    controller.nextPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.bounceIn);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
