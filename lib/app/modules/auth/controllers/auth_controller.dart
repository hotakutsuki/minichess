import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../data/userDom.dart';
import '../../../services/database.dart';

class AuthController extends GetxController {
  final _googleSignIn = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount?>(null);
  Rxn<User> user = Rxn<User>(null);
  late final DatabaseController dbController;

  login() async {
    googleAccount.value = await _googleSignIn.signIn();
    dbController = Get.find<DatabaseController>();
    if (googleAccount.value != null) {
      user.value = await dbController.getUserByUserId(googleAccount.value!.id);
      print('logged user: ${user.value}');
      if (user.value == null) {
        User newUser = User(
            googleAccount.value!.id,
            googleAccount.value!.displayName ?? 'user',
            googleAccount.value!.email,
            googleAccount.value!.photoUrl,
            5000);
        user.value = newUser;
        dbController.createNewUser(newUser);
      }
    } else {
      dbController.updateProfilePic(googleAccount.value!.photoUrl ?? '');
    }

  }

  logout() async {
    googleAccount.value = await _googleSignIn.signOut();
    user.value = null;
  }

  @override
  void onInit() {
    print('initing auth controller $googleAccount');
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
