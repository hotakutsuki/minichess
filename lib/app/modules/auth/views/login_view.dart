import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:minichess/app/modules/home/controllers/home_controller.dart';

import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  LoginView({Key? key}) : super(key: key);

  // HomeController homeController = Get.find<HomeController>();
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
                const Text('Minichess'),
              ],
            )),
            IconButton(
                onPressed: () => Get.back(closeOverlays: true),
                // onPressed: () => homeController.shouldShowDialog.value = false,
                icon: const Icon(Icons.close))
          ],
        ),
        const Text("Login or Create Account", style: TextStyle(fontSize: 20)),
        const Text('We need you to login in order to establish your score'),
        // Text(controller.contactText.value),
        // FloatingActionButton.extended(
        //   icon: Image.asset(
        //     'assets/images/glogo.png',
        //     height: 25,
        //   ),
        //   backgroundColor: Colors.white,
        //   foregroundColor: Colors.black,
        //   label: const Text('Login with google'),
        //   onPressed: () => controller.login(),
        // ),
        Obx(() {
          return TextField(
            controller: controller.userNameTextController,
            onSubmitted: (e) => controller.handleLoginOrCreate(),
            onChanged: (value) {
              controller.userNameTextController.value = TextEditingValue(
                  text: value.toLowerCase(),
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
                          : const Text('Login or Create Account')));
            }),
          ],
        ),
        const Divider(
          color: Colors.transparent,
        ),
      ],
    );
  }
}
