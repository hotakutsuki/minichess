import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:minichess/app/modules/home/controllers/home_controller.dart';

import '../../../data/enums.dart';
import '../controllers/auth_controller.dart';

class InsertNameView extends GetView<AuthController> {
  const InsertNameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 400,
        width: 420,
        child: SingleChildScrollView(
          child: Column(
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
                          Text(gameName, style: const TextStyle(fontSize: 20),),
                        ],
                      )),
                  IconButton(
                      onPressed: () => Get.back(closeOverlays: true),
                      // onPressed: () => homeController.shouldShowDialog.value = false,
                      icon: const Icon(Icons.close))
                ],
              ),
              const Text("What's gonna be your username?",
                  style: TextStyle(fontSize: 20)),
              const Divider(height: 30, color: Colors.transparent),
              const Text(
                  'An account will be created with your name to keep a record of your score'),
              const Divider(height: 30, color: Colors.transparent),
              Obx(() {
                return TextField(
                  controller: controller.userNameTextController,
                  onSubmitted: (e) => controller.createAndStartMultiplayer(),
                  onChanged: (value) {
                    controller.userNameTextController.value =
                        TextEditingValue(
                            text: value.removeAllWhitespace.toLowerCase(),
                            selection:
                            controller.userNameTextController.selection);
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
                '(Your user name must be unique)',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Divider(height: 30, color: Colors.transparent),
              Row(
                children: [
                  const Spacer(),
                  Obx(() {
                    return ElevatedButton(
                        onPressed: controller.createAndStartMultiplayer,
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
                                : const Text('Play Online')));
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
