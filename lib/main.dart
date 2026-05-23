import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:fiteo_myapp/app/app.dart';
import 'firebase_options.dart';

Future<void> setupFCM() async {
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print("NOTIFICATION PERMISSION: ${settings.authorizationStatus}");

  try {
    final token = await messaging.getToken();
    print("FCM TOKEN: $token");
  } catch (e) {
    print("FCM TOKEN ERROR: $e");
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print("NEW FCM TOKEN: $newToken");
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("FOREGROUND MESSAGE:");
    print(message.notification?.title);
    print(message.notification?.body);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupFCM();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  runApp(const FiteoApp());
}