import 'package:get/get.dart';
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
