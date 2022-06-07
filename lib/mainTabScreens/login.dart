import 'dart:core';
import 'package:cargpstracker/mainTabScreens/loginByPass.dart';
import 'package:cargpstracker/mainTabScreens/otpCode.dart';
import 'package:flutter/material.dart';
import 'package:cargpstracker/mainTabScreens/register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AutomaticKeepAliveClientMixin<LoginPage> {
  late String userPhone = '';
  @override
  void initState() {
    super.initState();
    // print('initState Live');
  }

  void sendCode() async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://130.185.77.83:4680/phoneVerify/'));
      request.fields.addAll({'phone': userPhone});
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final json = jsonDecode(responseString);
        // print(json);
        if (json["status"] == true) {
          Fluttertoast.showToast(msg: "sending-varify-code".tr);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      OtpPage(code: json["code"], userPhone: userPhone),
                  fullscreenDialog: false));
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/flutter-logo.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    userPhone = value;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'موبایل',
                    hintText: 'شماره تماس'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => LoginByPassPage(userPhone: userPhone),
                        fullscreenDialog: false));
              },
              child: Text(
                'Login With Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  sendCode();
                  // Navigator.pushReplacement(
                  // context,
                  // MaterialPageRoute(
                  // builder: (_) => RegisterPage(), fullscreenDialog: false));
                },
                child: Text(
                  "Login".tr,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
