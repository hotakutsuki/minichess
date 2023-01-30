import 'package:flutter/material.dart';

import 'package:get/get.dart';

class TutorialPageView extends GetView {
  const TutorialPageView(this.image, this.text, {Key? key}) : super(key: key);
  final String image, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          height: 300,
          padding: const EdgeInsets.all(16.0),
          child: Image.asset('assets/images/$image.png'),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 40,
            child: Text(text,
                textAlign: TextAlign.center,
                style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
          ),
        ),
      ],
    );
  }
}
