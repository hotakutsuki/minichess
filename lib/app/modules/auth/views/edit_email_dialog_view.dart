import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/utils.dart';
import '../../language/controllers/language_controller.dart';
import '../controllers/auth_controller.dart';

class EditEmailDialogView extends GetView<AuthController> {
  EditEmailDialogView({Key? key}) : super(key: key);
  final FocusNode newPassFocusNode = FocusNode();
  final FocusNode repeatNewPassFocusNode = FocusNode();
  LanguageController l = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 300,
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
                  Text(l.g('ChangingEmail')),
                ],
              ),
              TextField(
                controller: controller.newEmailTextController,
                onSubmitted: (e) => controller.handleEditEmail(),
                autofocus: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: Text(l.g('NewEmail')),
                  errorText: controller.newEmailError.value,
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  Obx(() {
                    return ElevatedButton(
                        onPressed: (){
                          playButtonSound();
                          controller.handleEditEmail();
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
                                : Text(l.g('UpdateEmail'))));
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
