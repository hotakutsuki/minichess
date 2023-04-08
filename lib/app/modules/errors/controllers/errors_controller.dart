import 'package:get/get.dart';

import '../views/errors_views.dart';

class ErrorsController extends GetxController {

  showGenericError([String? err]){
    Get.dialog(ErrorsViews.getErrorWidget(err));
  }

  @override
  void onInit() {
    print('initing errorsController');
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
