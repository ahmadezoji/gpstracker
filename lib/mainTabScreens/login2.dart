import 'dart:convert';
import 'dart:core';
import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/mainTabScreens/login3.dart';
import 'package:cargpstracker/mainTabScreens/otpCode.dart';
import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/models/user.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class Login2Page extends StatefulWidget {
  const Login2Page({Key? key, required this.userPhone, required this.validCode})
      : super(key: key);
  final String userPhone;
  final String validCode;
  @override
  _Login2PageState createState() => _Login2PageState();
}

class _Login2PageState extends State<Login2Page>
    with AutomaticKeepAliveClientMixin<Login2Page> {
  String signature = "{{ app signature }}";
  String? appSignature;
  late String userPhone = '';
  late bool isTrueOTP = false;
  late bool withPass = false;
  bool _isLoading = false;

  late String password = "";
  late String repassword = "";

  late bool passwordCorrect = false;

  late User currentUser;

  @override
  void initState() {
    super.initState();

    // SmsAutoFill().listenForCode();

    // SmsAutoFill().getAppSignature.then((signature) {
    // setState(() {
    // appSignature = signature;
    // });
    // });
  }

  @override
  void dispose() {
    // SmsAutoFill().unregisterListener();
    super.dispose();
  }

  void init() async {
    print(SmsAutoFill().listenForCode);
  }

  void updatePass(String password) async {
    print(widget.userPhone);
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/updatePass/'));
    request.fields.addAll({'phone': widget.userPhone, 'password': password});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  void updateShared() async {
    save(SHARED_ALLWAYS_PASS_KEY, 'true');
  }

  void addUser() async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/addUser/'));
      request.fields.addAll({'phone': widget.userPhone});
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final json = jsonDecode(responseString);
        if (json != null) {
          currentUser = User.fromJson(json);
          if (json["createdUser"] == true)
            Fluttertoast.showToast(msg: "add-user-msg".tr);
          else
            Fluttertoast.showToast(msg: "usr Exist");
          // saveJson(SHARED_USER_KEY, json)
          // .then((value) => print('shared json = $value'));
          save(SHARED_PHONE_KEY, widget.userPhone)
              .then((value) => print('shared uphone is = $value'));
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void goToNextStep() {
    if (withPass) {
      updatePass(password);
      updateShared();
    }

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => HomePage(
                userLogined: true, userDevices: [], currentUser: currentUser),
            fullscreenDialog: false));
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.blue,
    primary: Colors.white,
    minimumSize: Size(100, 46),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
  void onOTPChanged(bool otpStatuse) {
    setState(() {
      isTrueOTP = otpStatuse;
    });
    if (isTrueOTP) {
      addUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        backgroundColor: secondBackgroundPage,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("verification".tr,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IranSans')),
          backgroundColor: Colors.white, // status bar color
          // leading: Container(
          //     alignment: Alignment.center,
          //     width: 20,
          //     height: 20  ,
          //     child: Image.asset('assets/GPS+icon.png')),
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
            child: Container(
          padding: EdgeInsets.only(top: 50),
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/GPS+icon.png',
                width: 84,
                height: 84,
              ),
              Text("Validation code",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.blue)),
              if (isTrueOTP == false)
                validPlaceHolder(context, widget.validCode, onOTPChanged),
              SizedBox(height: 5),
              if (isTrueOTP == false)
                ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {},
                  child: Text(
                    isTrueOTP ? 'Ok' : 'Send again',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
              SizedBox(height: 20),
              Row(children: [
                Checkbox(
                    value: withPass,
                    onChanged: (value) => setState(() {
                          withPass = value!;
                        })),
                Text("loginWithPssTick".tr)
              ]),
              SizedBox(height: 20),
              if (withPass)
                Row(
                  children: [
                    Text("Password"),
                  ],
                ),
              if (withPass) SizedBox(height: 20),
              if (withPass)
                TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your password',
                    ),
                    onChanged: (value) => setState(() {
                          password = value;
                        })),
              if (withPass) SizedBox(height: 5),
              if (withPass)
                TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your password again',
                        fillColor: Colors.black),
                    onChanged: (value) => setState(() {
                          if (value != password)
                            setState(() {
                              passwordCorrect = false;
                            });
                          else
                            setState(() {
                              passwordCorrect = true;
                            });
                        })),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(
                  _isLoading ? 'Loading...' : 'Sumbmit',
                  style: const TextStyle(fontSize: 20),
                ),
                onPressed: isTrueOTP && withPass == false ||
                        (withPass && passwordCorrect)
                    ? goToNextStep
                    : null,
                style: ElevatedButton.styleFrom(fixedSize: const Size(250, 50)),
              ),
            ],
          ),
        )),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}

Widget validPlaceHolder(BuildContext context, String validCode, onOTPChanged) {
  String _validCode = "";
  bool enablity = true;

  // if (validCode.isNotEmpty) validCodeList = validCode.split("");

  late BoxDecoration boxdec = BoxDecoration(
    borderRadius: BorderRadius.circular(3),
    boxShadow: [
      BoxShadow(
        color: backPhoneNumberColor,
        spreadRadius: 2,
        // offset: const Offset(2, -6), // changes position of shadow
      ),
    ],
  );
  late TextStyle txtStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue);

  void onchanged(int index, String value) async {
    // SmsAutoFill().listenForCode();
    // print(await SmsAutoFill().getAppSignature);
    _validCode = _validCode + value;
    if (value.isNotEmpty) FocusScope.of(context).nextFocus();
    print(validCode);
    if (_validCode == validCode) {
      Fluttertoast.showToast(msg: "its ok");
      onOTPChanged(true);
    } else {
      enablity = true;
    }
  }

  return Container(
      // decoration: BoxDecoration(color: Colors.green),
      height: 100,
      width: 450,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              decoration: boxdec,
              width: 50,
              height: 50,
              child: TextField(
                  enabled: enablity,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  onChanged: ((value) => {onchanged(0, value)}),
                  textAlign: TextAlign.center,
                  style: txtStyle)),
          SizedBox(
            width: 20,
          ),
          Container(
              alignment: Alignment.center,
              decoration: boxdec,
              width: 50,
              height: 50,
              child: TextField(
                  enabled: enablity,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  onChanged: ((value) => {onchanged(1, value)}),
                  textAlign: TextAlign.center,
                  style: txtStyle)),
          SizedBox(
            width: 20,
          ),
          Container(
              alignment: Alignment.center,
              decoration: boxdec,
              width: 50,
              height: 50,
              child: TextField(
                  enabled: enablity,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  onChanged: ((value) => {onchanged(2, value)}),
                  textAlign: TextAlign.center,
                  style: txtStyle)),
          SizedBox(
            width: 20,
          ),
          Container(
              alignment: Alignment.center,
              decoration: boxdec,
              width: 50,
              height: 50,
              child: TextField(
                  enabled: enablity,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  onChanged: ((value) => {onchanged(3, value)}),
                  textAlign: TextAlign.center,
                  style: txtStyle)),
          SizedBox(
            width: 20,
          ),
          Container(
              alignment: Alignment.center,
              decoration: boxdec,
              width: 50,
              height: 50,
              child: TextField(
                  enabled: enablity,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  onChanged: ((value) => {onchanged(4, value)}),
                  textAlign: TextAlign.center,
                  style: txtStyle)),
          SizedBox(
            width: 20,
          )
        ],
      ));
}
