import 'dart:core';

import 'package:cargpstracker/models/user.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.currentUser}) : super(key: key);
  final User currentUser;

  @override
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  late String fullname;
  late String email;
  late String birthday;

  @override
  void initState() {
    super.initState();
    print(widget.currentUser.email);
    fullname =
        widget.currentUser.fullname.isEmpty ? "" : widget.currentUser.fullname;
    email = widget.currentUser.email.isEmpty ? "" : widget.currentUser.email;
    birthday =
        widget.currentUser.birthday.isEmail ? "" : widget.currentUser.birthday;
  }

  void _updatUser() {
    User newUser = User(
        fullname: fullname,
        email: email,
        phone: widget.currentUser.phone,
        birthday: birthday);
    updateUser(newUser);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      late double _headerWidth = MediaQuery.of(context).size.width;
      late double _headerHeight = MediaQuery.of(context).size.height * 0.15;
      late double _bodyHeight = MediaQuery.of(context).size.height * 0.75;
      late double _profileSpace = 130;
      return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: statusColor,

              // Status bar brightness (optional)
              statusBarIconBrightness:
                  Brightness.dark, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            title: Text("profile".tr, style: TextStyle(color: Colors.black)),
            backgroundColor: NabColor, // status bar color
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              // The containers in the background
              Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: _headerHeight,
                    color: ProfileheaderColor,
                  ),
                  Container(
                      alignment: Alignment.center,
                      height: _bodyHeight,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(top: 70),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                initialValue: fullname,
                                onChanged: (value) {
                                  setState(() {
                                    fullname = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "fullname".tr,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                initialValue: email,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "email".tr,
                                    hintText: email),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    birthday = value;
                                  });
                                },
                                initialValue: birthday,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "birthday".tr,
                                    hintText: birthday),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue,
                              ),
                              child: TextButton(
                                child: Text(
                                  'Apply'.tr,
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                                onPressed: () {
                                  _updatUser();
                                },
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    top: _headerHeight - (_profileSpace / 2),
                    left: _headerWidth * 0.5 - (_profileSpace / 2)),
                alignment: Alignment.center,
                width: _profileSpace,
                height: _profileSpace,
                decoration: BoxDecoration(
                    color: ProfileheaderColor,
                    borderRadius: BorderRadius.circular(_profileSpace / 2)),
                child: SvgPicture.asset(
                  'assets/profileimg.svg',
                ),
              )
            ],
          ));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
