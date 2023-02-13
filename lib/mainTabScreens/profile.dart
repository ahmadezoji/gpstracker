import 'dart:core';

import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.currentUser}) : super(key: key);
  final myUser currentUser;

  @override
  _ProfilePage2State createState() => _ProfilePage2State();
}

class _ProfilePage2State extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  late String fullname = widget.currentUser.fullname;
  late String email = widget.currentUser.email;
  late String birthday = widget.currentUser.birthday;
  late String pictureUrl = widget.currentUser.pictureUrl;

  @override
  void initState() {
    super.initState();
  }

  void _updatUser() async {
    try {
      myUser newUser = myUser(
          fullname: fullname,
          email: email,
          phone: widget.currentUser.phone,
          birthday: birthday,
          pictureUrl: "");
      myUser currentUser = (await updateUser(newUser))!;
      if (currentUser != null)
        Navigator.pop(context, {'user': currentUser});
      else
        Fluttertoast.showToast(msg: "error in update user");
    } catch (error) {
      Fluttertoast.showToast(msg: "error in update user");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        body: SingleChildScrollView(
          child: new Stack(
            children: <Widget>[
              // The containers in the background
              new Column(
                children: <Widget>[
                  new Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(top: 20),
                    height: MediaQuery.of(context).size.height * .20,
                    color: Colors.blue,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "profile".tr,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        top: 70, left: 10, right: 10, bottom: 20),
                    height: MediaQuery.of(context).size.height * .80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            TextFormField(
                              initialValue: fullname,
                              onChanged: (value) {
                                setState(() {
                                  fullname = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "profileContent-fullname".tr,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              initialValue: email,
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "profileContent-email".tr,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              initialValue: birthday,
                              onChanged: (value) {
                                setState(() {
                                  birthday = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "profileContent-birthday".tr,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          child: Text(
                            "apply".tr,
                            style: const TextStyle(fontSize: 20),
                          ),
                          onPressed: _updatUser,
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(300, 50)),
                        )
                      ],
                    ),
                  )
                ],
              ),
              // The card widget with top padding,
              // incase if you wanted bottom padding to work,
              // set the `alignment` of container to Alignment.bottomCenter
              new Container(
                alignment: Alignment.topCenter,
                padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .12,
                    right: 20.0,
                    left: 20.0),
                child: new Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(75)),
                  height: 125.0,
                  width: 125.0,
                  child: pictureUrl == ""
                      ? Image(image: AssetImage("assets/bigprofile.png"))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(45.0),
                          child: Image.network(
                            pictureUrl,
                            height: 90.0,
                            width: 90.0,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
