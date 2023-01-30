import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Login"),
            IconButton(
                onPressed: () => Get.back(closeOverlays: true),
                icon: const Icon(Icons.close))
          ],
        ),
        const Text('We need you to login in order to establish your score'),
        FloatingActionButton.extended(
          icon: Image.asset(
            'assets/images/glogo.png',
            height: 25,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          label: const Text('Login with google'),
          onPressed: () => controller.login(),
        ),
        const Divider(
          color: Colors.transparent,
        ),
      ],
    );
  }
}
