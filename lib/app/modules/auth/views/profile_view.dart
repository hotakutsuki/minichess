import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/userDom.dart';
import '../controllers/auth_controller.dart';

class ProfileView extends GetView<AuthController> {
  const ProfileView({Key? key}) : super(key: key);

  ImageProvider<Object> getAvatar() {
    if (controller.user.value?.photoUrl == null) {
      return Image.asset('assets/images/pawnW.png').image;
    }
    return Image.network(controller.user.value?.photoUrl ?? '').image;
  }

  Widget editableElement(String field, action) {
    return Row(
      children: [
        Text('${field.capitalizeFirst}:'),
        const Spacer(),
        Text(controller.user.value?.getProperty(field) ?? 'not defined'),
        TextButton(onPressed: action, child: const Icon(Icons.edit))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueGrey,
                backgroundImage: controller.user.value?.photoUrl == null
                    ? Image.asset('assets/icon/icon.png').image
                    : Image.network(controller.user.value!.photoUrl!).image,
                radius: 75,
                child: controller.uploading.value
                    ? const CircularProgressIndicator()
                    : null,
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.orangeAccent,
                  heroTag: 'editButton',
                  onPressed: controller.selectFile,
                  child: const Icon(Icons.edit),
                ),
              ),
            ],
          ),
          Text('@${controller.user.value?.name ?? ''}',
              style: const TextStyle(fontSize: 28)),
          Text('${controller.user.value?.score ?? 'loading...'}',
              style: const TextStyle(fontSize: 28)),
          editableElement(User.EMAIL, () => {}),
          editableElement(User.COUNTRY, () => {}),
          editableElement(User.CITY, () => {}),
          editableElement(User.PASSWORD, () => {}),
          const Divider(
            color: Colors.transparent,
          ),
          OutlinedButton(
              onPressed: () => controller.logout(),
              child: const Text("logout")),
        ],
      );
    });
  }
}
