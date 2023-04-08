import 'package:get/get.dart';
import 'package:minichess/app/modules/errors/controllers/errors_controller.dart';

import '../../auth/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {

  @override
  void dependencies() {
    print('binding home');
    Get.put(HomeController());
    // Get.lazyPut<HomeController>(
    //   () => HomeController(),
    // );
  }
}
