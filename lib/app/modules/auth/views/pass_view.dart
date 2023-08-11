import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:minichess/app/modules/home/controllers/home_controller.dart';

import '../controllers/auth_controller.dart';

class PassView extends GetView<AuthController> {
  PassView({Key? key}) : super(key: key);

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
        const Text("Enter Password", style: TextStyle(fontSize: 20)),
        Obx(() {
          return TextField(
            controller: controller.passTextController,
            autofocus: true,
            obscureText: true,
            onSubmitted: (e) => controller.handlePassword(),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: const Text('Password'),
              errorText: controller.passError.value,
            ),
          );
        }),
        Row(
          children: [
            TextButton(
                onPressed: () => {controller.userName.value = null},
                child: controller.loading.value
                    ? const CircularProgressIndicator()
                    : Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: const Text('Cancel'))),
            const Spacer(),
            Obx(() {
              return ElevatedButton(
                  onPressed: controller.handlePassword,
                  child: Container(
                          height: 40,
                          width: 80,
                          alignment: Alignment.center,
                          child: controller.loading.value
                              ? const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))
                              : const Text('Accept')));
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
