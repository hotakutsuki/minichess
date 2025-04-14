import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/utils.dart';
import '../../../data/enums.dart';
import '../../language/controllers/language_controller.dart';
import '../../language/views/select_languaje_widget.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  LoginView({Key? key}) : super(key: key);
  LanguageController l = Get.find<LanguageController>();

  googleButton() {
    return FloatingActionButton.extended(
      icon: Image.asset(
        'assets/images/glogo.png',
        height: 25,
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      label: Text(l.g('LoginWithGoogle')),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                          width: 30,
                          child: Image.asset('assets/images/icon.png')),
                      Text(l.g('LoginSignUp'),
                          style: const TextStyle(fontSize: 18),
                          overflow: TextOverflow.fade),
                    ],
                  )),
              IconButton(
                  onPressed: () => Get.back(closeOverlays: true),
                  icon: const Icon(Icons.close))
            ],
          ),
          const Divider(),
          const Divider(height: 10, color: Colors.transparent,),
          Text(l.g('WhatYourUsername'), style: const TextStyle(fontSize: 16)),
          const Divider(height: 20, color: Colors.transparent),
          Text(
            l.g('EstablishYourScore'), style: const TextStyle(fontSize: 14),),
          const Divider(height: 30, color: Colors.transparent),
          Obx(() {
            return TextField(
              controller: controller.userNameTextController,
              onSubmitted: (e) => controller.handleLoginOrCreate(),
              onChanged: (value) {
                controller.userNameTextController.value = TextEditingValue(
                    text: value.removeAllWhitespace.toLowerCase(),
                    selection: controller.userNameTextController.selection);
              },
              autofocus: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(l.g('UserName')),
                errorText: controller.userNameError.value,
              ),
            );
          }),
          Text(
            l.g('YouCantChangeThisLater'),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const Divider(height: 30, color: Colors.transparent),
          Row(
            children: [
              const Spacer(),
              Obx(() {
                return ElevatedButton(
                    onPressed: () {
                      playButtonSound();
                      controller.handleLoginOrCreate();
                    },
                    child: Container(
                        height: 40,
                        width: 200,
                        alignment: Alignment.center,
                        child: controller.loading.value
                            ? const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                            : Text(controller.tryStartMultuplayer ? l.g(
                            'PlayOnline') : l.g('LoginOrCreateAccount'))));
              }),
            ],
          ),
          const Divider(color: Colors.transparent, height: 30,),
          LanguageSelectionWidget(),
        ],
      );
    });
  }
}
