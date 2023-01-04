import 'dart:convert';
import 'dart:core';

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

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AutomaticKeepAliveClientMixin<LoginPage> {
  late String userPhone = '';
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    // print('initState Live');
  }

  void sendCode() async {
    setState(() {
      _isLoading = true;
    });
    String sentCode = (await OTPverify(userPhone))!;
    print('code : $sentCode');
    Fluttertoast.showToast(msg: "sending-varify-code".tr);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                Login2Page(userPhone: userPhone, validCode: sentCode),
            fullscreenDialog: false));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        backgroundColor: loginBackgroundColor,
        appBar: AppBar(
          title: Text("login".tr,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IranSans')),
          backgroundColor: Colors.white, // status bar color
          // leading: Image.asset("assets/speed-alarm.png"),
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: statusColor,

            // Status bar brightness (optional)
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.asset('assets/GPS+icon.png')),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: backPhoneNumberColor,
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset:
                            const Offset(2, -6), // changes position of shadow
                      ),
                    ],
                  ),
                  child: IntlPhoneField(
                    decoration: InputDecoration(
                      // labelText: "phone_entry".tr,
                      fillColor: backPhoneNumberColor,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        userPhone = value.countryCode + value.number;
                      });
                    },
                    onCountryChanged: (country) {
                      // print('Country changed to: ' + country.code);
                    },
                    initialCountryCode: "IR",
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Divider(color: Colors.black),
                    Container(
                      width: 250,
                      color: secondBackgroundPage,
                      alignment: Alignment.center,
                      child: Text("Sign in with Google or Facebook?"),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 170,
                child: Row(
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () => print('on facebook clicked'),
                      child: Image.asset('assets/facebook.png'),
                    ),
                    SizedBox(width: 40),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () => print('on google clicked'),
                      child: Image.asset('assets/google.png'),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: _isLoading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.login),
                label: Text(
                  _isLoading ? 'Loading...' : 'Login',
                  style: const TextStyle(fontSize: 20),
                ),
                onPressed: _isLoading ? null : sendCode,
                style: ElevatedButton.styleFrom(fixedSize: const Size(250, 50)),
              ),
              SizedBox(
                height: 130,
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
