import 'dart:convert';
import 'dart:core';

import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/user.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Login4Page extends StatefulWidget {
  const Login4Page(
      {Key? key, required this.userDevices, required this.currentUser})
      : super(key: key);
  final List<Device> userDevices;
  final User currentUser;

  @override
  _Login4PageState createState() => _Login4PageState();
}

class _Login4PageState extends State<Login4Page>
    with AutomaticKeepAliveClientMixin<Login4Page> {
  late String userPhone = '';
  late String password = "";
  late bool rememberPass = false;
  bool _isLoading = false;
  bool _obscureText = true;
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSHared();
    // _controller.text = 'Complete the story from here...';
  }

  void updateShared() {
    save(SHARED_REMEMBERED_PASS_KEY, password);
  }

  void loadSHared() async {
    String _password = (await load(SHARED_REMEMBERED_PASS_KEY))!;
    passController..text = _password;
    setState(() {
      password = _password;
    });
  }

  void goToNextStep() async {
    updateShared();
    print(widget.currentUser.phone + password);
    bool status = (await loginWithPass(widget.currentUser.phone, password))!;
    if (status)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => new HomePage(
                currentUser: widget.currentUser,
                userLogined: true,
                userDevices: widget.userDevices)),
      );
    else
      Fluttertoast.showToast(msg: 'password is incorrect');
  }

  void onRememberMyPass(bool? status) {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text("login".tr,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'IranSans')),
            systemOverlayStyle: const SystemUiOverlayStyle(),
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
                      width: 200,
                      height: 150,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text("Password"),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          // color: NabColor,
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: passController,
                              autofocus: true,
                              autocorrect: false,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter your password',
                                // filled: true,
                                // icon: IconButton(
                                //   icon: Icon(Icons.remove_red_eye,
                                //       color: _obscureText ? Colors.red : Colors.blue),
                                //   onPressed: () => setState(() {
                                //     _obscureText = !_obscureText;
                                //   }),
                                // ),
                              ),
                              onChanged: (value) => setState(
                                () {
                                  password = value;
                                },
                              ),
                              obscureText: _obscureText,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_red_eye,
                                color: _obscureText ? Colors.red : Colors.blue),
                            onPressed: () => setState(() {
                              _obscureText = !_obscureText;
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: rememberPass,
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
            ),
          ));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
