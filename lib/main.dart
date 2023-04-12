import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:firebase_notifications_handler/firebase_notifications_handler.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/modules/errors/controllers/errors_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/database.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Get.put(AuthController(), permanent: true);
  Get.put(ErrorsController(), permanent: true);
  Get.put(DatabaseController(), permanent: true);

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
      print('doing something in android');
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

  runApp(
    FutureBuilder(
      future: _fbApp,
      builder: (context, snapshot) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
        if (snapshot.hasError){
          return const Text("There was an error. try again later");
        } else if (snapshot.hasData) {
          return FirebaseNotificationsHandler(
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Inti: The Sun Game",
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ),
  );
}
