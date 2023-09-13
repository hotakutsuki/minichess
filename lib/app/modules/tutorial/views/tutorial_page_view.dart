import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inti_the_inka_chess_game/app/utils/utils.dart';

class TutorialPageView extends GetView {
  const TutorialPageView(this.image, this.text, {Key? key}) : super(key: key);
  final String image, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 24,
            child: Text(text,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          ),
        ),
        Container(
          // height: 500,
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: SizedBox(
                    height: getScale(context) * 380,
                    // width: 310,
                    // color: Colors.red,
                    child: Image.asset(
                      'assets/images/tutorial/$image.png',
                      fit: BoxFit.fitHeight,
                    )),
              ),
              Center(
                  child: SizedBox(
                      height: getScale(context) * 420,
                      child: Image.asset(
                        'assets/images/border.png',
                        fit: BoxFit.fitHeight,
                      ))),
            ],
          ),
        ),
      ],
    );
  }
}
