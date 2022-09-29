import 'package:cargpstracker/LacaleString.dart';
import 'package:cargpstracker/spalshScreen.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static const String ACCESS_TOKEN =
      'pk.eyJ1Ijoic2FhbWV6b2ppIiwiYSI6ImNsNDJvZ3RoeTB1NWMzZG82YnVodGU1d2EifQ.x3z9Smy3JJcwy-bNzHsZ6A';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              translations: LocaleString(),
              locale: Locale('en','US'),
              title: 'App_Name'.tr,
              theme: themeNotifier.isDark ? ThemeData.dark() : ThemeData.light(),
              home: SpalshScreen(),
            );
          }),
    );
  }
}
