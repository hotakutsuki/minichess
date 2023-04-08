import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class ProfileView extends GetView<AuthController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Divider(color: Colors.transparent),
          CircleAvatar(
            backgroundImage:
            Image
                .network(controller.googleAccount.value?.photoUrl ?? '')
                .image,
            radius: 75,
          ),
          const Divider(color: Colors.transparent),
          Text('Score: ${controller.user.value?.score ?? 'loading...'}'),
          Text(controller.user.value?.name ?? ''),
          Text(controller.googleAccount.value?.email ?? ''),
          const Divider(color: Colors.transparent),
          OutlinedButton(
              onPressed: () => controller.logout(),
              child: const Text("logout")),
        ],
      );
    });
  }
}
