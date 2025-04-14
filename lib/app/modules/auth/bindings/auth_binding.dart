import 'package:get/get.dart';

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
