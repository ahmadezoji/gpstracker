import 'package:cargpstracker/mainTabScreens/GpsPlus.dart';
import 'package:cargpstracker/mainTabScreens/history.dart';
import 'package:cargpstracker/mainTabScreens/live.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    GpsPlus(),
    Live(),
    History(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    initFirebase();
    super.initState();
  }

  void initFirebase() async {
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    // FirebaseMessaging.instance.onTokenRefresh
    //     .listen((fcmToken) {
    // })
    //     .onError((err) {
    //   // Error getting token.
    // });
    //
    // await FirebaseMessaging.instance.setAutoInitEnabled(true);

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );


    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

  }

  @override
  Widget build(BuildContext context) {
    late Color selectedFontColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    late Color unselectedFontColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    late Color backColor = Theme.of(context).brightness == Brightness.dark
        ? backNavBarDark
        : backgroundColor;
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        // body: Center(
        //   child: _widgetOptions.elementAt(_selectedIndex),
        // ),
        body: IndexedStack(
          children: <Widget>[
            GpsPlus(),
            Live(),
            History(),
          ],
          index: _selectedIndex,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: backColor,
          items: <BottomNavigationBarItem>[
            // BottomNavigationBarItem(
            //   icon: Image(image: AssetImage("assets/gpsplus.png")),
            //   label: 'Plus'.tr,
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Plus'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Live'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History'.tr,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: selectedFontColor,
          onTap: _onItemTapped,
          // fixedColor: Colors.red,
          selectedLabelStyle: TextStyle(color: Colors.red, fontSize: 20),
          unselectedFontSize: 16,
          selectedIconTheme:
              IconThemeData(color: Colors.blue, opacity: 1.0, size: 30.0),
          unselectedItemColor: unselectedFontColor,
          unselectedLabelStyle: TextStyle(fontSize: 18, color: Colors.pink),
        ),
      );
    });
  }
}
