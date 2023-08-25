import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/enums.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
          child: Column(
            children: [
              Text(
                gameName,
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(color: Colors.transparent,),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
