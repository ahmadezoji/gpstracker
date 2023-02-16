import 'dart:core';

import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class Login3Page extends StatefulWidget {
  @override
  _Login3PageState createState() => _Login3PageState();
}

class _Login3PageState extends State<Login3Page>
    with AutomaticKeepAliveClientMixin<Login3Page> {
  late String userPhone = '';
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    // print('initState Live');
  }

  void goToNextStep() {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
          backgroundColor: secondBackgroundPage,
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
          body: Container(
            padding: EdgeInsets.only(top: 100),
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/GPS+icon.png',
                    width: 200,
                    height: 150,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [Text("Phone Number")],
                  ),
                  SizedBox(height: 5),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onChanged: (phone) {
                      setState(() {
                        userPhone = phone as String;
                      });
                    },
                    onCountryChanged: (country) {
                      // print('Country changed to: ' + country.code);
                    },
                    initialCountryCode: "IR",
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: _isLoading
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.login),
                    label: Text(
                      _isLoading ? 'Loading...' : 'Send code',
                      style: const TextStyle(fontSize: 20),
                    ),
                    onPressed: _isLoading ? null : goToNextStep,
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 50)),
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
                          onPressed: goToNextStep,
                          child: Image.asset('assets/facebook.png'),
                        ),
                        SizedBox(width: 40),
                        FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: goToNextStep,
                          child: Image.asset('assets/google.png'),
                        )
                      ],
                    ),
                  )
                ]),
          ));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
