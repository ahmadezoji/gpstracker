import 'dart:core';
import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/mainTabScreens/otpCode.dart';
import 'package:flutter/material.dart';
import 'package:cargpstracker/mainTabScreens/register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginByPassPage extends StatefulWidget {
  const LoginByPassPage({Key? key, required this.userPhone}) : super(key: key);
  final String userPhone;
  @override
  _LoginByPassPageState createState() => _LoginByPassPageState();
}

class _LoginByPassPageState extends State<LoginByPassPage>
    with AutomaticKeepAliveClientMixin<LoginByPassPage> {
  late String userPhone;
  late String password;
  @override
  void initState() {
    super.initState();
    // print('initState Live');
  }

  void loginWithPass() async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://130.185.77.83:4680/loginByPass/'));
      request.fields.addAll({
        'phone': userPhone,
        'password': password,
      });
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final json = jsonDecode(responseString);
        print(json["status"]);
        if (json["status"] == true) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('phone', userPhone).then((bool success) {
            print(success);
          });

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => HomePage(), fullscreenDialog: false));
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
        title: Text("LoginByPass Page"),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          userPhone = value;
                        });
                      },
                      keyboardType: TextInputType.number,
                      // controller: TextEditingController(
                      //     text: widget.userPhone == null
                      //         ? 'شماره تماس'
                      //         : widget.userPhone),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'موبایل',
                          hintText: 'شماره تماس'),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'رمز عبور',
                          hintText: 'رمز عبور'),
                    ),
                  ],
                )),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  loginWithPass();
                },
                child: Text(
                  "Login".tr,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
