import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/userDom.dart';
import '../../../services/database.dart';

class AuthController extends GetxController {
  final _googleSignIn = GoogleSignIn(scopes: [
    'email',
  ],);
  var googleAccount = Rx<GoogleSignInAccount?>(null);
  Rxn<User> user = Rxn<User>(null);
  late final DatabaseController dbController;
  final RxString contactText = 'asd'.obs;

  login() async {
    // print('login... ${_googleSignIn.requestScopes(['s'])}');
    // googleAccount.value = await _googleSignIn.signIn();
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print('error: $error');
      contactText.value = error.toString();
    }
  }

  setUserInfoInBD() async {
    print('googleAccount: ${googleAccount.value}');
    if (googleAccount.value != null) {
      var response = await http.get(Uri.parse('http://ip-api.com/json'));
      Map<String, dynamic> ipJson = jsonDecode(response.body);
      user.value = await dbController.getUserByUserId(googleAccount.value!.id);
      print('logged user: ${user.value}');
      if (user.value == null) {
        User newUser = User(
          googleAccount.value!.id,
          googleAccount.value!.displayName ?? 'user',
          googleAccount.value!.email,
          googleAccount.value!.photoUrl,
          5000,
          ipJson.containsKey(User.COUNTRY) ? ipJson[User.COUNTRY] : '',
          ipJson.containsKey(User.COUNTRYCODE) ? ipJson[User.COUNTRYCODE] : '',
          ipJson.containsKey(User.CITY) ? ipJson[User.COUNTRYCODE] : '',
        );
        user.value = newUser;
        dbController.createNewUser(newUser);
      } else {
        dbController.updateInfo(
          googleAccount.value!.photoUrl ?? '',
          ipJson['country'] ?? '',
          ipJson['countryCode'] ?? '',
          ipJson['city'] ?? '',
        );
      }
    }
  }

  logout() async {
    googleAccount.value = await _googleSignIn.signOut();
    user.value = null;
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    contactText.value = 'Loading contact info...';
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      contactText.value = 'People API gave a ${response.statusCode} '
          'response. Check logs for details.';

      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
    json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    if (namedContact != null) {
      contactText.value = 'I see you know $namedContact!';
    } else {
      contactText.value = 'No contacts to display.';
    }
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
            (dynamic name) =>
        (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  @override
  void onInit() {
    print('initing auth controller $googleAccount');
    super.onInit();
  }

  @override
  void onReady() async {
    dbController = Get.find<DatabaseController>();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      print('current user changed... $account');
      if (account != null) {
        googleAccount.value = account;
        setUserInfoInBD();
        _handleGetContact(googleAccount.value!);
      }
    });
    print('singin silently');
    await _googleSignIn.signInSilently();
    print('current user: ${_googleSignIn.currentUser}');
    // print('about to run login...');
    // login();
    // print('setting');
    // setUserInfoInBD();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
