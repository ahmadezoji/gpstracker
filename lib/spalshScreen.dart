import 'dart:async';
import 'dart:io';

import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/mainTabScreens/signOn.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';



Widget getMarkerPoint() {
  return Lottie.asset("assets/point.json");
}

class SpalshScreen extends StatefulWidget {
  static const String id = "SpalshScreen";
  final void Function() onInit;
  SpalshScreen({required this.onInit});
  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  late AnimationController controller;
  List<int>? pattern;
  List<Device> devicesList = [];
  late myUser currentUser;

  @override
  void initState() {
    super.initState();
    widget.onInit();
    HttpOverrides.global = MyHttpOverrides();
    Timer(Duration(seconds: 3), () => pushPage());
  }

  void getShared() async {
    try {
      String? email = await load(SHARED_EMAIL_KEY);
      String? withPass = await load(SHARED_ALLWAYS_PASS_KEY);

      // String phone = "09192592697";
      // String withPass = "true";
      email = "saam.ezoji@gmail.com";
      if (email != null) {
        // currentUser = (await getUser(email))!;
        // devicesList = (await getUserDevice(currentUser))!;

        if (withPass == "true") {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => new Login4Page(
          //           currentUser: currentUser, userDevices: devicesList)),
          // );

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => new HomePage(
          //           currentUser: currentUser,
          //           userLogined: true,
          //           userDevices: devicesList)),
          // );
        } else {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => new HomePage(
          //           currentUser: currentUser,
          //           userLogined: true,
          //           userDevices: devicesList)),
          // );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => new SignOnPage()),
        );
      }
    } catch (e) {
      print('exception : $e');
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
      // String email = "saam.ezoji@gmail.com";
      // currentUser = (await getUser(email))!;
      // devicesList = (await getUserDevice(currentUser))!;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

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
    // controller.dispose();
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
              Lottie.asset('assets/new-splash-screen.json'),
              // CircularProgressIndicator(
              //   value: controller.value,
              //   semanticsLabel: 'Linear progress indicator',
              // ),
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
