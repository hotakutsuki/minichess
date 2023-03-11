import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/modules/errors/controllers/errors_controller.dart';
import 'app/modules/match/controllers/match_making_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/database.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(AuthController(), permanent: true);
  Get.put(ErrorsController(), permanent: true);
  Get.put(DatabaseController(), permanent: true);
  // Get.lazyPut<MatchMakingController>(
  //       () => MatchMakingController(),
  // );
  // Get.put(MatchMakingController(), permanent: true);

  runApp(
    FutureBuilder(
      future: _fbApp,
      builder: (context, snapshot) {
        if (snapshot.hasError){
          return const Text("There was an error. try again later");
        } else if (snapshot.hasData) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Application",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ),
  );
}
