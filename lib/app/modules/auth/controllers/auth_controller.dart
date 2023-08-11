import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/userDom.dart';
import '../../../services/database.dart';
import 'package:minichess/app/data/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  // final _googleSignIn = GoogleSignIn(scopes: [
  //   'email',
  //   'https://www.googleapis.com/auth/contacts.readonly',
  // ],);
  // var googleAccount = Rx<GoogleSignInAccount?>(null);
  User? tempUser;
  Rxn<User> user = Rxn<User>(null);
  Rxn<String> userName = Rxn<String>(null);
  Rxn<String> userNameError = Rxn<String>(null);
  late final DatabaseController dbController;
  final RxString contactText = ''.obs;
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController passTextController = TextEditingController();
  Rxn<String> passError = Rxn<String>(null);
  final RxBool loading = false.obs;

  login(User userToLogin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(sharedPrefs.userName.name , userToLogin.name);

    user.value = userToLogin;
    userName.value = null;
    // print('login... ${_googleSignIn.requestScopes(['s'])}');
    // googleAccount.value = await _googleSignIn.signIn();
    try {
      // print('login with google...');
      // await _googleSignIn.signIn();
      // print('logged...');
    } catch (error) {
      // print('error: $error');
      // contactText.value = '$error';
    }
  }

  trySilentLogin() async {
    print('trying silent login');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userName = prefs.getString(sharedPrefs.userName.name);
    print('userName: $userName');
    if (userName != null) {
      tempUser = await dbController.getUserByUserName(userName);
      if (tempUser != null){
        user.value = tempUser;
      }
    }
  }

  logout() async {
    user.value = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(sharedPrefs.userName.name);
    Get.back(closeOverlays: true);
  }

  handleLoginOrCreate() async {
    userNameError.value = null;
    if (userNameTextController.text.length < 4) {
      userNameError.value = "Invalid User Name";
      return;
    }

    loading.value = true;
    tempUser =
        await dbController.getUserByUserName(userNameTextController.text);
    // await Future.delayed(const Duration(milliseconds: 500));
    // User tempUser = User('id', 'name', 'email', 'photurl', 123, 'country',
    //     'countrycode', 'city', null);
    if (tempUser == null) {
      try {
        await dbController.createNewUserByUserName(userNameTextController.text);
        handleLoginOrCreate();
      } catch (e) {
        return;
      }
    } else if (tempUser!.password != null) {
      userName.value = tempUser!.name;
    } else {
      await login(tempUser!);
      clearFields();
    }
    loading.value = false;
  }

  clearFields() {
    userNameTextController.clear();
    passTextController.clear();
  }

  handlePassword() async {
    passError.value = null;
    loading.value = true;
    // await Future.delayed(const Duration(milliseconds: 500));
    // User tempUser = User('id', 'name', 'email', 'photurl', 123, 'country',
    //     'countrycode', 'city', 'password');
    if (tempUser!.password != passTextController.text) {
      passError.value = 'Invalid Password';
    } else {
      user.value = tempUser;
    }
    loading.value = false;
  }

  // googleSetUserInfoInBD() async {
  //   print('googleAccount: ${googleAccount.value}');
  //   if (googleAccount.value != null) {
  //     Map<String, dynamic> ipJson = <String, dynamic>{};
  //     try {
  //       var response = await http.get(Uri.parse('http://ip-api.com/json'));
  //       ipJson = jsonDecode(response.body);
  //     } catch(e) {
  //       print(e);
  //     }
  //     user.value = await dbController.getUserByUserId(googleAccount.value!.id);
  //     print('logged user: ${user.value}');
  //     if (user.value == null) {
  //       User newUser = User(
  //         googleAccount.value!.id,
  //         googleAccount.value!.displayName ?? 'user',
  //         googleAccount.value!.email,
  //         googleAccount.value!.photoUrl,
  //         5000,
  //         ipJson.containsKey(User.COUNTRY) ? ipJson[User.COUNTRY] : '',
  //         ipJson.containsKey(User.COUNTRYCODE) ? ipJson[User.COUNTRYCODE] : '',
  //         ipJson.containsKey(User.CITY) ? ipJson[User.COUNTRYCODE] : '',
  //       );
  //       user.value = newUser;
  //       dbController.createNewUser(newUser);
  //     } else {
  //       dbController.updateInfo(
  //         googleAccount.value!.photoUrl ?? '',
  //         ipJson['country'] ?? '',
  //         ipJson['countryCode'] ?? '',
  //         ipJson['city'] ?? '',
  //       );
  //     }
  //   }
  // }

  // googleLogout() async {
  //   googleAccount.value = await _googleSignIn.signOut();
  //   user.value = null;
  // }

  // Future<void> _googleHandleGetContact(GoogleSignInAccount user) async {
  //   contactText.value = 'Loading contact info...';
  //   final http.Response response = await http.get(
  //     Uri.parse('https://people.googleapis.com/v1/people/me/connections'
  //         '?requestMask.includeField=person.names'),
  //     headers: await user.authHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     contactText.value = 'People API gave a ${response.statusCode} '
  //         'response. Check logs for details.';
  //
  //     print('People API ${response.statusCode} response: ${response.body}');
  //     return;
  //   }
  //   final Map<String, dynamic> data =
  //   json.decode(response.body) as Map<String, dynamic>;
  //   final String? namedContact = _pickFirstNamedContact(data);
  //   if (namedContact != null) {
  //     contactText.value = 'I see you know $namedContact!';
  //   } else {
  //     contactText.value = 'No contacts to display.';
  //   }
  // }

  // String? _pickFirstNamedContact(Map<String, dynamic> data) {
  //   final List<dynamic>? connections = data['connections'] as List<dynamic>?;
  //   final Map<String, dynamic>? contact = connections?.firstWhere(
  //         (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
  //     orElse: () => null,
  //   ) as Map<String, dynamic>?;
  //   if (contact != null) {
  //     final List<dynamic> names = contact['names'] as List<dynamic>;
  //     final Map<String, dynamic>? name = names.firstWhere(
  //           (dynamic name) =>
  //       (name as Map<Object?, dynamic>)['displayName'] != null,
  //       orElse: () => null,
  //     ) as Map<String, dynamic>?;
  //     if (name != null) {
  //       return name['displayName'] as String?;
  //     }
  //   }
  //   return null;
  // }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    dbController = Get.find<DatabaseController>();
    super.onReady();
    if(user.value == null){
      trySilentLogin();
    }
    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
    //   print('current user changed... $account');
    //   if (account != null) {
    //     googleAccount.value = account;
    //     setUserInfoInBD();
    //     _handleGetContact(googleAccount.value!);
    //   }
    // });
    // print('singin silently');
    // await _googleSignIn.signInSilently();
    // print('current user: ${_googleSignIn.currentUser}');
    // print('about to run login...');
    // login();
    // print('setting');
    // setUserInfoInBD();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
