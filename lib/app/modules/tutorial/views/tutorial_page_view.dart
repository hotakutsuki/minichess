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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 20,
            child: Text(text,
                textAlign: TextAlign.center,
                style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
          ),
        ),
        Container(
          height: 500,
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 400,
                    child: Image.asset('assets/images/tutorial/$image.png')),
              ),
              Center(child: Image.asset('assets/images/border.png')),
            ],
          ),
        ),
      ],
    );
  }
}
