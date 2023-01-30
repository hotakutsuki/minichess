import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


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
