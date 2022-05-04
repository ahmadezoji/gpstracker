import 'dart:async';
import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/mainTabScreens/start.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:developer';

class SpalshScreen extends StatefulWidget {
  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    // fetch();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);

    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage())));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void fetch() async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://185.208.175.202:4680/getConfig/'));
      request.fields.addAll({'serial': '027028362416'});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final json = convert.jsonDecode(responseString);
        String serial = json["device_id_id"].toString();
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('serial', serial).then((bool success) {
          print(serial);
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error add project $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Lottie.asset(
                'assets/gps-pointer.json'),
            CircularProgressIndicator(
              value: controller.value,
              semanticsLabel: 'Linear progress indicator',
            ),
          ],
        ),
      ),
    );
  }
}
