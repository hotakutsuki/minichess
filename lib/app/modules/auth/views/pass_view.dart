import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/utils.dart';
import '../../../data/enums.dart';
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
        Row(
          children: [
            SizedBox(
              child: IconButton(
                onPressed: controller.clearUserName,
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            Text(controller.userName.value ?? ''),
          ],
        ),
        const Text("Enter Password", style: TextStyle(fontSize: 20)),
        const Divider(
          color: Colors.transparent,
        ),
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
        const Divider(
          color: Colors.transparent,
        ),
        const Text(
            'Forgot your password? contact us for support'),
        const Divider(
          color: Colors.transparent,
        ),
        Row(
          children: [
            const Spacer(),
            Obx(() {
              return ElevatedButton(
                  onPressed: (){playButtonSound();controller.handlePassword();},
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
                          : Text(controller.tryStartMultuplayer ? 'Play Online' : 'Login')));
            }),
          ],
        ),
      ],
    );
  }
}
