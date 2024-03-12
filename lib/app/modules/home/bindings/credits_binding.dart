import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../views/credits_view.dart';

class CreditsBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(CreditsView());
  }
}
