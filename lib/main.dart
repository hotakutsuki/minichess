import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:firebase_notifications_handler/firebase_notifications_handler.dart';
import 'package:inti_the_inka_chess_game/app/utils/utils.dart';
import 'app/data/enums.dart';
import 'app/modules/home/controllers/home_controller.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/modules/errors/controllers/errors_controller.dart';
import 'app/modules/home/controllers/intro_tale_controller.dart';
import 'app/modules/language/controllers/language_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/database.dart';
import 'app/utils/gameObjects/BackgroundController.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Get.put(AuthController(), permanent: true);
  Get.put(ErrorsController(), permanent: true);
  Get.put(DatabaseController(), permanent: true);
  Get.put(HomeController(), permanent: true);
  // Get.put(IntroTaleController(), permanent: true);
  Get.put(BackgroundController(), permanent: true);
  Get.put(LanguageController(), permanent: true);
  Get.lazyPut(()=>IntroTaleController());

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'mini_chess_channel', // id
    'Mini Chess Notifications', // title
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('recieven a message');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: android.smallIcon,
            ),
          ));
    }
  });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);

  runApp(
      GetMaterialApp(
        defaultTransition: Transition.noTransition,
        debugShowCheckedModeBanner: false,
        title: gameName,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        theme: ThemeData(
            textTheme: const TextTheme(
              bodyLarge: TextStyle(),
              bodyMedium: TextStyle(),
            ).apply(
              bodyColor: Colors.white70,
              displayColor: Colors.orangeAccent,
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: brackgroundColor,
              secondary: brackgroundColor,
            ),
            scaffoldBackgroundColor: const Color(0xFFAAAAAA)
        ),
      )
  );
}
