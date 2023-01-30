import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:minichess/app/modules/auth/views/profile_view.dart';

import '../controllers/auth_controller.dart';
import 'login_view.dart';

class LoginDialogView extends GetView<AuthController> {
  const LoginDialogView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 400,
        child: Obx(() {
          if (controller.googleAccount.value == null) {
            return LoginView();
          } else {
            return ProfileView();
          }
        }),
      ),
    );
  }
}
