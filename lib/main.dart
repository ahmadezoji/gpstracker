import 'package:cargpstracker/LacaleString.dart';
import 'package:cargpstracker/mainTabScreens/GpsPlus.dart';
import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/spalshScreen.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
// import 'package:firebase_core/firebase_core.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//
//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: LocaleString(),
          locale: Locale('en', 'US'),
          title: "App_Name".tr,
          // theme: themeNotifier.isDark ? ThemeData.dark() : ThemeData.light(),
          theme: themeNotifier.isDark
              ? ThemeData(
                  brightness: Brightness.dark,
                  // primarySwatch: Colors.blue,
                  // textTheme: TextTheme(
                  //   headline1: TextStyle(color: Colors.white),
                  //   headline2: TextStyle(color: Colors.white),
                  //   bodyText2: TextStyle(color: Colors.white),
                  //   subtitle1: TextStyle(color: Colors.white),
                  //   subtitle2: TextStyle(color: Colors.white),
                  // ),
                )
              : ThemeData(
                  brightness: Brightness.light,
                  appBarTheme: AppBarTheme(backgroundColor: NabColor),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                      backgroundColor: Colors.white)
                  // textTheme: TextTheme(
                  //   headline1: TextStyle(color: Colors.black),
                  //   headline2: TextStyle(color: Colors.black),
                  //   bodyText2: TextStyle(color: Colors.black),
                  //   subtitle1: TextStyle(color: Colors.black),
                  //   subtitle2: TextStyle(color: Colors.black),
                  // ),
                  ),
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => SpalshScreen(),
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/gpsplus': (context) => GpsPlus(),
            '/login': (context) => LoginPage(),
          },
          // home: SpalshScreen(),
        );
      }),
    );
  }
}
