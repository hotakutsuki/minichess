import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minichess/utils/LoginController.dart';

class ProfileState extends StatelessWidget {
  ProfileState({super.key});
  final controller = Get.put(LoginController());

  Widget buildProfileView () {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: Image.network(controller.googleAccount.value?.photoUrl ?? '').image,
          radius: 75,
        ),
        Text(controller.googleAccount.value?.displayName ?? ''),
        Text(controller.googleAccount.value?.email ?? ''),
        ElevatedButton(onPressed: () => controller.logout(), child: const Text("logout")),
      ],
    );
  }

  Widget buildLoginButton() {
    return Center(
      child: ElevatedButton(
        child: const Text("login with google"),
        onPressed: () {
          controller.login();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        if (controller.googleAccount.value == null) {
          return buildLoginButton();
        } else {
          return buildProfileView();
        }
      }),
    );
  }
}