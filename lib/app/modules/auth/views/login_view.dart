import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:minichess/app/modules/home/controllers/home_controller.dart';

import '../../../data/enums.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  LoginView({Key? key}) : super(key: key);

  googleButton() {
    return FloatingActionButton.extended(
      icon: Image.asset(
        'assets/images/glogo.png',
        height: 25,
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      label: const Text('Login with google'),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    width: 30, child: Image.asset('assets/images/icon.png')),
                Text(gameName, style: const TextStyle(fontSize: 20),),
              ],
            )),
            IconButton(
                onPressed: () => Get.back(closeOverlays: true),
                // onPressed: () => homeController.shouldShowDialog.value = false,
                icon: const Icon(Icons.close))
          ],
        ),
        const Divider(),
        const Divider(height: 10, color: Colors.transparent,),
        const Text("What's gonna be your username?", style: TextStyle(fontSize: 20)),
        const Divider(height: 20, color: Colors.transparent),
        const Text('We need you to login in order to establish your score'),
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
              label: const Text('User Name'),
              errorText: controller.userNameError.value,
            ),
          );
        }),
        const Text(
          '(You wont be able to change your user name in the future)',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const Divider(height: 30, color: Colors.transparent),
        Row(
          children: [
            const Spacer(),
            Obx(() {
              return ElevatedButton(
                  onPressed: controller.handleLoginOrCreate,
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
                          : Text(controller.tryStartMultuplayer ? 'Play Online' : 'Login or Create Account')));
            }),
          ],
        ),
      ],
    );
  }
}
