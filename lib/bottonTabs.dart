import 'package:cargpstracker/mainTabScreens/GpsPlus.dart';
import 'package:cargpstracker/mainTabScreens/history.dart';
import 'package:cargpstracker/mainTabScreens/live.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'firebase_options.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget(
      {Key? key,
      required this.userLogined,
      required this.userDevices,
      required this.currentUser})
      : super(key: key);
  final List<Device> userDevices;
  final bool userLogined;
  final myUser currentUser;
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 1;
  bool activeLive = true;
  void _onItemTapped(int index) {
    if (index == 1)
      activeLive = true;
    else
      activeLive = false;
    setState(() {
      _selectedIndex = index;
    });
  }

  // late bool userLogined = false;

  @override
  void initState() {
    // initFirebase();
    // init();
    super.initState();
  }
  //
  // void init() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? phone = prefs.getString('phone');
  //   if (phone == null)
  //     userLogined = false;
  //   else {
  //     userLogined = true;
  //   }
  // }

  // void initFirebase() async {
  //   // final fcmToken = await FirebaseMessaging.instance.getToken();
  //   // FirebaseMessaging.instance.onTokenRefresh
  //   //     .listen((fcmToken) {
  //   // })
  //   //     .onError((err) {
  //   //   // Error getting token.
  //   // });
  //   //
  //   // await FirebaseMessaging.instance.setAutoInitEnabled(true);
  //
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User granted permission');
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     print('User granted provisional permission');
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }
  // }

  // Future<bool> getLoginStatus() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? phone = prefs.getString('phone');
  //   if (phone == null)
  //     return false;
  //   else
  //     return true;
  // }

  @override
  Widget build(BuildContext context) {
    late bool isDark = Theme.of(context).brightness == Brightness.dark;
    late Color selectedFontColor = isDark ? Colors.white : Colors.black;
    late Color unselectedFontColor = isDark ? Colors.white : Colors.black;
    late Color backColor = isDark ? backNavBarDark : backgroundColor;
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        // body: Center(
        //   child: _widgetOptions.elementAt(_selectedIndex),
        // ),
        body: IndexedStack(
          children: <Widget>[
            new GpsPlus(),
            Live(
                active: activeLive,
                userLogined: widget.userLogined,
                userDevices: widget.userDevices,
                currentUser: widget.currentUser),
            History(
                userLogined: widget.userLogined,
                userDevices: widget.userDevices,
                currentUser: widget.currentUser),
            // !userLogined ? GpsPlusDemo() : GpsPlus(),
            // !userLogined ? LiveDemo() : Live(),
            // !userLogined ? HistoryDemo() : History(),
          ],
          index: _selectedIndex,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: backColor,
          items: <BottomNavigationBarItem>[
            // BottomNavigationBarItem(
            //   activeIcon: isDark ? SvgPicture.asset("assets/dark/plus-icon-selected.svg"):SvgPicture.asset("assets/light/plus-icon-selected.svg"),
            //   icon: isDark ? SvgPicture.asset("assets/dark/plus-icon.svg"):SvgPicture.asset("assets/light/plus-icon.svg"),
            //   label: 'Plus'.tr,
            // ),
            // BottomNavigationBarItem(
            //   activeIcon: isDark ? SvgPicture.asset("assets/dark/live-icon-selected.svg"):SvgPicture.asset("assets/light/live-icon-selected.svg"),
            //   icon: isDark ? SvgPicture.asset("assets/dark/live-icon.svg"):SvgPicture.asset("assets/light/live-icon.svg"),
            //   label: 'Live'.tr,
            // ),
            // BottomNavigationBarItem(
            //   activeIcon: isDark ? SvgPicture.asset("assets/dark/history-icon-selected.svg"):SvgPicture.asset("assets/light/history-icon-selected.svg"),
            //   icon: isDark ? SvgPicture.asset("assets/dark/history-icon.svg"):SvgPicture.asset("assets/light/history-icon.svg"),
            //   label: 'History'.tr,
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
          selectedLabelStyle: TextStyle(color: Colors.red, fontSize: 16),
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
