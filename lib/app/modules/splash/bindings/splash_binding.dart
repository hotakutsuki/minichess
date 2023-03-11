import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../errors/controllers/errors_controller.dart';
import '../../match/controllers/match_making_controller.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    print('dependencies splash');
    // Get.put(AuthController(), permanent: true);
    // Get.lazyPut<AuthController>(
    //       () => AuthController(),
    // );
    // Get.put(ErrorsController(), permanent: true);
    // Get.lazyPut<ErrorsController>(
    //       () => ErrorsController(),
    // );
    Get.put(SplashController());
  }
}
