import 'dart:async';
import 'dart:io';

import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/mainTabScreens/signOn.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/user.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import 'mainTabScreens/login4.dart';
Widget getMarkerPoint(){
  return  Lottie.asset("assets/point.json");
}
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

    HttpOverrides.global = MyHttpOverrides();
    // controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 3),
    // )..addListener(() {
    //     getShared();
    //   });
    // controller.repeat(reverse: false);

    Timer(Duration(seconds: 3), () => getShared());
  }

  void getShared() async {
    try {
      String? email = await load(SHARED_EMAIL_KEY);
      String? withPass = await load(SHARED_ALLWAYS_PASS_KEY);

      // String phone = "09192592697";
      // String withPass = "true";
      if (email != null) {
        currentUser = (await getUser(email))!;
        devicesList = (await getUserDevice(currentUser))!;
        if (withPass == "true") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => new Login4Page(
                    currentUser: currentUser, userDevices: devicesList)),
          );

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => new HomePage(
          //           currentUser: currentUser,
          //           userLogined: true,
          //           userDevices: devicesList)),
          // );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => new HomePage(
                    currentUser: currentUser,
                    userLogined: true,
                    userDevices: devicesList)),
          );
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
