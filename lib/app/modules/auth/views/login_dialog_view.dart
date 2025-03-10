import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:inti_the_inka_chess_game/app/modules/auth/views/pass_view.dart';
import 'package:inti_the_inka_chess_game/app/modules/auth/views/profile_view.dart';
import '../controllers/auth_controller.dart';
import 'login_view.dart';

class LoginDialogView extends GetView<AuthController> {
  const LoginDialogView({Key? key}) : super(key: key);

  getChild(){
    if (controller.user.value != null) {
      return ProfileView();
    } else if (controller.userName.value != null) {
      return PassView();
    } else {
      return LoginView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(255, 255, 255, .80),
      content: SizedBox(
        height: 450,
        width: 420,
        child: Obx(() {
          return SingleChildScrollView(
            child: getChild(),
          );
        }),
      ),
    );
  }
}
