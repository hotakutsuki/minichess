import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/utils.dart';
import '../../language/controllers/language_controller.dart';
import '../controllers/auth_controller.dart';

class NewPasswordDialogView extends GetView<AuthController> {
  NewPasswordDialogView({Key? key}) : super(key: key);
  final FocusNode newPassFocusNode = FocusNode();
  final FocusNode repeatNewPassFocusNode = FocusNode();
  LanguageController l = Get.find<LanguageController>();

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
                  Text(l.g('ChangingPassword')),
                ],
              ),
              ...(controller.user.value?.password != null ? [TextField(
                controller: controller.oldPasswordTextController,
                onSubmitted: (e) => newPassFocusNode.requestFocus(),
                autofocus: true,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: Text(l.g('OldPassword')),
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
                  label: Text(l.g('NewPassword')),
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
                  label: Text(l.g('RepeatNewPassword')),
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
                                : Text(l.g('ChangePassword'))));
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
