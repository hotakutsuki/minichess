import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class ProfileView extends GetView<AuthController> {
  const ProfileView({Key? key}) : super(key: key);

  ImageProvider<Object> getAvatar() {
    if (controller.user.value?.photoUrl == null) {
      print('1');
      return Image.asset('assets/images/pawnW.png').image;
    }
    print('2');
    return Image.network(controller.user.value?.photoUrl ?? '').image;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Divider(color: Colors.transparent),
          CircleAvatar(
            backgroundColor: Colors.blueGrey,
            backgroundImage: controller.user.value?.photoUrl == null
                ? Image.asset('assets/icon/icon.png').image
                : Image.network(controller.user.value?.photoUrl ?? '').image,
            radius: 75,
          ),
          const Divider(color: Colors.transparent),
          Text('Score: ${controller.user.value?.score ?? 'loading...'}'),
          Text(controller.user.value?.name ?? ''),
          // Text(controller.user.value?.email ?? ''),
          const Divider(color: Colors.transparent),
          OutlinedButton(
              onPressed: () => controller.logout(),
              child: const Text("logout")),
        ],
      );
    });
  }
}
