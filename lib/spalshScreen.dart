import 'dart:async';
import 'package:cargpstracker/home.dart';
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

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    super.initState();
    // fetch();
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => StartPage())));
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
    return Container(
        color: Colors.white,
        child: Column(children: [
          Lottie.network(
              'https://assets5.lottiefiles.com/packages/lf20_f9lgn7bp.json'),
        ]));
  }
}