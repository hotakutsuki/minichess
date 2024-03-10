import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:inti_the_inka_chess_game/app/modules/home/controllers/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/enums.dart';
import '../../../language/lang_en.dart' as en;
import '../../../language/lang_es.dart' as es;
import '../../../language/lang_ki.dart' as ki;

class LanguageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final HomeController homeController = Get.find<HomeController>();
  late SharedPreferences prefs;
  final Rxn<languages> language = Rxn<languages>(null);

  late final AnimationController logoController =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    language.value = languages.values.firstWhere(
        (e) => e.name == prefs.getString(sharedPrefs.language.name));
    super.onInit();
  }

  //general purpose function to get localized strings
  String getLocalizedString(String key) {
    switch (language.value) {
      case languages.en:
        return en.english[key] ?? key;
      case languages.es:
        return es.spanish[key] ?? en.english[key] ?? key;
      case languages.ki:
        return ki.kichwa[key] ?? en.english[key] ?? key;
      default:
        return en.english[key] ?? key;
    }
  }

  String g(String key) {
    return getLocalizedString(key);
  }

  void setLanguage(languages s) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language', s.name);
    language.value = languages.values.firstWhere(
        (e) => e.name == prefs.getString(sharedPrefs.language.name));
  }

  void goToHomeScreen() {
    Get.offAllNamed('/home');
  }
}
