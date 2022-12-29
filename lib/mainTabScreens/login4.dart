import 'dart:convert';
import 'dart:core';

import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/mainTabScreens/login2.dart';
import 'package:cargpstracker/mainTabScreens/otpCode.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/user.dart';
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

class Login4Page extends StatefulWidget {
  const Login4Page({Key? key, required this.phone}) : super(key: key);
  final String phone;
  @override
  _Login4PageState createState() => _Login4PageState();
}

class _Login4PageState extends State<Login4Page>
    with AutomaticKeepAliveClientMixin<Login4Page> {
  late String userPhone = '';
  late String password = "";
  late bool rememberPass = false;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    // print('initState Live');
  }

  void goToNextStep() async {
    User? currentUser = await loginWithPass(widget.phone, password);
    List<Device>? devicesList = (await getUserDevice(widget.phone))!;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => new HomePage(
              currentUser: currentUser,
              userLogined: true,
              userDevices: devicesList)),
    );
  }

  void onRememberMyPass(bool? status) {}
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
                  SizedBox(height: 50),
                  Row(
                    children: [
                      Text("Password"),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your password',
                      ),
                      onChanged: (value) => setState(() {
                            password = value;
                          })),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: false,
                              onChanged: (value) => setState(() {
                                    rememberPass = value!;
                                  })),
                          Text("Remeber password")
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new LoginPage()),
                          );
                        },
                        child: Text(
                          'Forget password?',
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),
                      ),
                    ],
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
                    onPressed: _isLoading ? null : goToNextStep,
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 50)),
                  )
                ]),
          ));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
