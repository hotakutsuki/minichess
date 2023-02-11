import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
            children: const [
              Text(
                'MiniChess',
                style: TextStyle(fontSize: 20),
              ),
              Divider(color: Colors.transparent,),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
