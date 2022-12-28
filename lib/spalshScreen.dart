import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/user.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpalshScreen extends StatefulWidget {
  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  List<int>? pattern;
  List<Device> devicesList = [];
  late User currentUser;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIOverlays ([]);
    getShared();
    HttpOverrides.global = MyHttpOverrides();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {});
    controller.repeat(reverse: false);

    // Timer(Duration(seconds: 3), () => pushPage());
  }

  void getShared() async {
    try {
      // Future<String?> phone = load(SHARED_PHONE_KEY);
      String phone = "09127060772";
      // ignore: unnecessary_null_comparison
      if (phone != null) {
        currentUser = await getUser(phone) as User;
        devicesList = (await getUserDevice(phone))!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => new HomePage(
                  currentUser: currentUser,
                  userLogined: true,
                  userDevices: devicesList)),
        );
      } else {
        //Demo mode
        phone = "09127060772";
        currentUser = await getUser(phone) as User;
        devicesList = (await getUserDevice(phone))!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => new HomePage(
                  currentUser: currentUser,
                  userLogined: true,
                  userDevices: devicesList)),
        );
      }
    } catch (e) {
      // print(e);
    }

    // phone = "09127060772";
    // if (phone == null || phone == '') {
    // userLogined = false;
    // getUserDevice("09127060772").then((list) async {
    //   devicesList = list!;
    //   pushPage();
    // });
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => new LoginPage()));
    // } else {
    // userLogined = true;
    // getUserDevice(phone).then((list) async {
    //   devicesList = list!;
    //   pushPage();
    // });
    // }
  }

  void pushPage() async {
    try {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => new HomePage(
      //           userLogined: userLogined, userDevices: devicesList)),
      // );

      // final prefs = await SharedPreferences.getInstance();
      // String? phone = prefs.getString('phone');
      // print(phone);
      // if (phone == null) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => LoginPage()),
      //   );
      // } else {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => HomePage()),
      //   );
      // }
    } catch (error) {
      print('Error add project $error');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Lottie.asset('assets/splash-screen.json'),
              CircularProgressIndicator(
                value: controller.value,
                semanticsLabel: 'Linear progress indicator',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
