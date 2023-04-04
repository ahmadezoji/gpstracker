import 'dart:core';

import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/main.dart';
import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class Login2Page extends StatefulWidget {
  const Login2Page({Key? key, required this.authUser, required this.userPhone})
      : super(key: key);
  final User? authUser;
  final String? userPhone;

  @override
  _Login2PageState createState() => _Login2PageState();
}

class _Login2PageState extends State<Login2Page>
    with
        AutomaticKeepAliveClientMixin<Login2Page>,
        SingleTickerProviderStateMixin {
  String signature = "{{ app signature }}";
  String? appSignature;
  late bool isTrueOTP = false;
  late bool withPass = false;
  bool _isLoading = false;
  late String? currentCode = "";
  late String phone = "";
  late String password = "";
  late String repassword = "";
  late bool passwordCorrect = false;
  late myUser? currentUser;
  late FirebaseMessaging messaging;
  late String fcmToken = "";

  @override
  void initState() {
    super.initState();
    initFirebaseFCM();
    _listenOtp();
    if (widget.authUser != null) {
      setState(() {
        isTrueOTP = true;
      });
    } else {
      sendCode();
    }

    // print('ValidCode : ${widget.validCode}');
    // SmsAutoFill().listenForCode();

    // SmsAutoFill().getAppSignature.then((signature) {
    // setState(() {
    // appSignature = signature;
    // });
    // });
  }

  void _listenOtp() async {
    // await SmsAutoFill().listenForCode();
    // print("OTP Listen is called");
  }

  void initFirebaseFCM() {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      setState(() {
        fcmToken = value!;
      });
      print('fcmToken = $fcmToken ,,, phone=${widget.userPhone}');
      // _addUserAuth();
      // _addUserOTP();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  @override
  void dispose() {
    // SmsAutoFill().unregisterListener();
    super.dispose();
  }

  void init() async {}

  void sendCode() async {
    String? sentCode = await OTPverify(widget.userPhone!);
    setState(() {
      currentCode = sentCode;
    });
  }

  void _addUserOTP() async {
    try {
      String? phone = widget.userPhone;
      myUser user = myUser(
          fullname: "",
          email: "",
          phone: phone!,
          birthday: "",
          pictureUrl: "",
          fcmToken: fcmToken);
      currentUser = (await addUser(user))!;
      if (currentUser != null) {
        save(SHARED_PHONE_KEY, widget.userPhone!)
            .then((value) => print('shared uphone is = $value'));
      }
    } catch (error) {
      print('_addUser Exception= $error');
    }
  }

  void _updateUser(myUser tmpuser) async {
    await updateUser(tmpuser);
  }

  void _addUserAuth() async {
    try {
      final _pictureUrl = widget.authUser!.photoURL ?? "";
      final _fullname = widget.authUser!.displayName ?? "";
      final _email = widget.authUser!.email ?? "saam@gmail.com";
      final _phone = phone;
      final _fcmToken = fcmToken;
      final _birthday = "";
      myUser user = myUser(
          fullname: _fullname.toString(),
          email: _email.toString(),
          phone: _phone.toString(),
          birthday: _birthday.toString(),
          pictureUrl: _pictureUrl.toString(),
          fcmToken: _fcmToken);
      currentUser = (await addUser(user));
      if (currentUser!.fcmToken.toString() != fcmToken) {
        myUser tmpuser = myUser(
            fullname: currentUser!.fullname,
            email: currentUser!.email,
            phone: currentUser!.phone,
            birthday: currentUser!.birthday,
            pictureUrl: currentUser!.pictureUrl,
            fcmToken: _fcmToken);
        _updateUser(tmpuser);
      }
      print(currentUser);
      if (currentUser != null) {
        save(SHARED_EMAIL_KEY, currentUser!.email)
            .then((value) => print('shared email is = $value'));

        if (withPass) {
          updatePass(currentUser!, password);
          save(SHARED_ALLWAYS_PASS_KEY, withPass.toString());
        }
        List<Device> devicesList = (await getUserDevice(currentUser!))!;
        StoreProvider.of<AppState>(context)
            .dispatch(FetchDataAction(devicesList, currentUser));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => HomePage(), fullscreenDialog: false));
      } else {}
    } catch (error) {
      print('_addUser Exception= $error');
    }
  }

  void goToNextStep() async {
    _addUserAuth();

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
      _addUserOTP();
    }
  }

  _sendAgain() async {
    // String? sentCode = await OTPverify(widget.userPhone!);
    // print('code : $sentCode');
    // setState(() {
    //   currentCode = sentCode!;
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        // backgroundColor: secondBackgroundPage,
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("verification".tr)),
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
                  SizedBox(height: 50),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your phone',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        val!.length < 8 ? 'Phone not correct.' : null,
                    onChanged: (value) => setState(
                      () {
                        phone = value;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  if (isTrueOTP == false)
                    validPlaceHolder(context, currentCode!, onOTPChanged),
                  SizedBox(height: 10),
                  if (isTrueOTP == false)
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {
                        _sendAgain();
                      },
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
                    Text("loginWithPassTick".tr)
                  ]),
                  SizedBox(height: 20),
                  if (withPass)
                    const Row(
                      children: [
                        Text("Password"),
                      ],
                    ),
                  if (withPass) SizedBox(height: 20),
                  if (withPass)
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your password',
                      ),
                      validator: (val) =>
                          val!.length < 6 ? 'Password too short.' : null,
                      onChanged: (value) => setState(
                        () {
                          password = value;
                        },
                      ),
                    ),
                  if (withPass) SizedBox(height: 5),
                  if (withPass)
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your password again',
                          fillColor: Colors.black),
                      validator: (val) =>
                          val != password ? 'Passwords not match .' : null,
                      onChanged: (value) => setState(
                        () {
                          if (value != password)
                            setState(() {
                              passwordCorrect = false;
                            });
                          else
                            setState(() {
                              passwordCorrect = true;
                            });
                        },
                      ),
                    ),
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
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 50)),
                  ),
                ],
              )),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}

Widget validPlaceHolder(BuildContext context, String validCode, onOTPChanged) {
  final List<String> validCodeArray = ["", "", "", "", ""];
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
  void onchanged(BuildContext context, int index, String value) async {
    if (value.isEmpty) {
      validCodeArray[index] = '';
      return;
    }
    validCodeArray[index] = value;
    String _validCode = "";
    validCodeArray.forEach((element) {
      if (element.isNotEmpty) _validCode = _validCode + element;
    });
    print('_validCode : $_validCode');
    if (_validCode == validCode) {
      Fluttertoast.showToast(msg: "validation complete");
      onOTPChanged(true);
    }
    FocusScope.of(context).nextFocus();
  }

  return Container(
    alignment: Alignment.center,
    height: 50,
    child: Center(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: validCodeArray.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: boxdec,
              child: TextFormField(
                  enabled: true,
                  decoration: InputDecoration(border: InputBorder.none),
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(1),
                  ],
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  onChanged: ((value) => onchanged(context, index, value)),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: txtStyle),
            );
          }),
    ),
  );
}
