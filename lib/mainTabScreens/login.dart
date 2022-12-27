import 'dart:convert';
import 'dart:core';

import 'package:cargpstracker/mainTabScreens/login2.dart';
import 'package:cargpstracker/mainTabScreens/loginByPass.dart';
import 'package:cargpstracker/mainTabScreens/otpCode.dart';
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
    try {
      if (userPhone.isEmpty) {
        Fluttertoast.showToast(msg: 'please fill phone number');
        return;
      }
      setState(() {
        _isLoading = true;
      });
      var request =
          http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/phoneVerify/'));
      request.fields.addAll({'phone': userPhone});
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final json = jsonDecode(responseString);
        print(json);
        if (json["status"] == true) {
          Fluttertoast.showToast(msg: "sending-varify-code".tr);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      Login2Page(userPhone: userPhone, validCode: json["code"]),
                  fullscreenDialog: false));
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {}
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
                padding: const EdgeInsets.only(top: 160.0),
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
              // TextButton(
              //   onPressed: () {
              //     Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //             builder: (_) => LoginByPassPage(userPhone: userPhone),
              //             fullscreenDialog: false));
              //   },
              //   child: Text(
              //     'Login With Password',
              //     style: TextStyle(color: Colors.blue, fontSize: 15),
              //   ),
              // ),
              SizedBox(height: 50),
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
