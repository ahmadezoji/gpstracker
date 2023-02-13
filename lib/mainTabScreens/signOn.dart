import 'dart:convert';
import 'dart:core';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cargpstracker/mainTabScreens/login2.dart';
import 'package:cargpstracker/mainTabScreens/otpCode.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../autentication.dart';

class SignOnPage extends StatefulWidget {
  @override
  _SignOnPageState createState() => _SignOnPageState();
}

class _SignOnPageState extends State<SignOnPage>
    with AutomaticKeepAliveClientMixin<SignOnPage> {
  late String userPhone = "";

  @override
  void initState() {
    super.initState();
    Authentication.initializeFirebase();
  }

  Future<void> _handleSignIn() async {
    try {
      User? user = await Authentication.signInWithGoogle(context: context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => Login2Page(authUser: user!),
              fullscreenDialog: false));
    } catch (error) {
      print(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(title: Text("signOn".tr)),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 100, right: 20, left: 20),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('assets/GPS+icon.png')),
              ),
              SizedBox(
                height: 100,
              ),
              Text(
                'Wellcome!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'find yourself with GPS+',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () => _handleSignIn(),
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 60,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/google.png',
                        height: 30,
                        width: 30,
                      ),
                      Text(
                        'SignOn with google',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
