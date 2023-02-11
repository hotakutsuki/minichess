import 'package:get/get.dart';

import 'package:minichess/app/modules/auth/controllers/user_controller.dart';

import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    print('putting Auth');
    // Get.lazyPut<UserController>(
    //   () => UserController(),
    // );
    // Get.lazyPut<AuthController>(
    //   () => AuthController(),
    // );
  }
}
