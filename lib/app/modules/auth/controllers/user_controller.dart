import 'package:get/get.dart';

import '../../../data/userDom.dart';

class UserController extends GetxController {
  Rxn<User> _user = Rxn<User>();

  User? get user => _user.value;

  set user(User? value) => this._user.value;

  void clear(){
    _user = Rxn<User>();
  }

  @override
  void onInit() {
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
