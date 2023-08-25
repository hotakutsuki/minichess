import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/enums.dart';
import '../controllers/auth_controller.dart';
import 'edit_email_dialog_view.dart';
import 'new_password_dialog_view.dart';

class ProfileView extends GetView<AuthController> {
  const ProfileView({Key? key}) : super(key: key);

  ImageProvider<Object> getAvatar() {
    if (controller.user.value?.photoUrl == null) {
      return Image.asset('assets/images/pieces/wkingd.png').image;
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

  Widget editPassword() {
    return SingleChildScrollView(
      child: TextField(
        controller: controller.passTextController,
        onSubmitted: (e) => controller.handleLoginOrCreate(),
        autofocus: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: const Text('User Name'),
          errorText: controller.userNameError.value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  SizedBox(
                      width: 30, child: Image.asset('assets/images/icon.png')),
                  const Text(
                    'Your Account',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              )),
              IconButton(
                  onPressed: () => Get.back(closeOverlays: true),
                  icon: const Icon(Icons.close))
            ],
          ),
          const Divider(
            height: 20,
          ),
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: brackgroundColor,
                backgroundImage: controller.uploading.value
                    ? null
                    : controller.user.value?.photoUrl == null
                        ? Image.asset('assets/images/icon.png').image
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
          Text(
              '@${controller.user.value?.name ?? ''} / ${controller.user.value?.countryCode ?? 'unk'}',
              style: const TextStyle(fontSize: 28)),
          Text('${controller.user.value?.score ?? 'loading...'}',
              style: const TextStyle(fontSize: 28)),
          Row(
            children: [
              const Text('Email:'),
              const Spacer(),
              Text(controller.user.value?.email ?? 'not defined'),
              IconButton(
                  onPressed: () {
                    Get.dialog(EditEmailDialogView(), barrierDismissible: true);
                  },
                  icon: const Icon(Icons.edit))
            ],
          ),
          Row(
            children: [
              const Text('Password:'),
              const Spacer(),
              Text(controller.user.value?.password != null
                  ? "••••••••"
                  : 'not defined'),
              IconButton(
                  onPressed: () {
                    Get.dialog(NewPasswordDialogView(),
                        barrierDismissible: true);
                  },
                  icon: const Icon(Icons.edit)),
            ],
          ),
          OutlinedButton(
            onPressed: () => controller.logout(),
            child: const Text(
              "logout",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      );
    });
  }
}
