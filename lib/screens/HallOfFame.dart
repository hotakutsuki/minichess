import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HallOfFame extends StatelessWidget {
  HallOfFame({super.key});

  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: controller,
          children: const [Text('asd'), Text('123')],
        ),
        // bottomNavigationBar: NavigationBar(
        //   destinations: const [
        //     Navi
        //     Text('asd'),
        //     Text('1123'),
        //   ],
        );
  }
}
