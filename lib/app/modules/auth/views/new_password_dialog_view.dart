import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/utils.dart';
import '../controllers/auth_controller.dart';

class NewPasswordDialogView extends GetView<AuthController> {
  NewPasswordDialogView({Key? key}) : super(key: key);
  final FocusNode newPassFocusNode = FocusNode();
  final FocusNode repeatNewPassFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 320,
        width: 380,
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    child: IconButton(
                      onPressed: (){Get.back();},
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const Text("Changing Password"),
                ],
              ),
              ...(controller.user.value?.password != null ? [TextField(
                controller: controller.oldPasswordTextController,
                onSubmitted: (e) => newPassFocusNode.requestFocus(),
                autofocus: true,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: const Text('Old Password'),
                  errorText: controller.oldPasswordError.value,
                ),
              )] : []),
              TextField(
                focusNode: newPassFocusNode,
                autofocus: controller.user.value?.password == null,
                controller: controller.newPasswordTextController,
                onSubmitted: (e) => repeatNewPassFocusNode.requestFocus(),
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: const Text('New Password'),
                  errorText: controller.newPasswordError.value,
                ),
              ),
              TextField(
                focusNode: repeatNewPassFocusNode,
                controller: controller.repeatNewPasswordTextController,
                onSubmitted: (e) => controller.handleChangePassword(),
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: const Text('Repeat New Password'),
                  errorText: controller.repeatNewPasswordError.value,
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  Obx(() {
                    return ElevatedButton(
                        onPressed: (){
                          playButtonSound();
                          controller.handleChangePassword();
                        },
                        child: Container(
                            height: 40,
                            width: 140,
                            alignment: Alignment.center,
                            child: controller.loading.value
                                ? const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                                : const Text('Change Password')));
                  }),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
