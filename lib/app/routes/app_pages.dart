import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/hallOfFame/bindings/hall_of_fame_binding.dart';
import '../modules/hallOfFame/views/hall_of_fame_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/match/bindings/match_binding.dart';
import '../modules/match/views/match_view.dart';
import '../modules/tutorial/bindings/tutorial_binding.dart';
import '../modules/tutorial/views/tutorial_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.MATCH,
      page: () => MatchView(),
      binding: MatchBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.TUTORIAL,
      page: () => const TutorialView(),
      binding: TutorialBinding(),
    ),
    GetPage(
      name: _Paths.HALL_OF_FAME,
      page: () => const HallOfFameView(),
      binding: HallOfFameBinding(),
    ),
  ];
}
