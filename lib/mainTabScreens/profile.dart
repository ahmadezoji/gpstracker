import 'dart:core';

import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.userPhone}) : super(key: key);
  final String userPhone;

  @override
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  late String userName;
  late String phone;
  late String email;
  late String country;
  late String city;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle kStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w900,
    );
    late double _headerWidth = MediaQuery
        .of(context)
        .size
        .width;
    late double _headerHeight = MediaQuery
        .of(context)
        .size
        .height * 0.25;
    late double _bodyHeight = MediaQuery
        .of(context)
        .size
        .height * 0.75;
    late double _profileSpace = 130;
    return Scaffold(
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
                    child: Padding(padding: EdgeInsets.only(top: 70 ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                onChanged: (value) =>
                                    setState(() {
                                      userName = value;
                                    }),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  filled: true,
                                  fillColor: textFeildColor,
                                  labelText: "username".tr,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                onChanged: (value) =>
                                    setState(() {
                                      phone = value;
                                    }),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  filled: true,
                                  fillColor: textFeildColor,
                                  labelText: "phone".tr,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                onChanged: (value) =>
                                    setState(() {
                                      email = value;
                                    }),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  filled: true,
                                  fillColor: textFeildColor,
                                  labelText: "email".tr,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                onChanged: (value) =>
                                    setState(() {
                                      country = value;
                                    }),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  filled: true,
                                  fillColor: textFeildColor,
                                  labelText: "country".tr,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                onChanged: (value) =>
                                    setState(() {
                                      city = value;
                                    }),
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  filled: true,
                                  fillColor: textFeildColor,
                                  labelText: "city".tr,
                                ),
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
                                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                                ),
                                onPressed: () {
                                },
                              ),
                            ),
                          ],
                        ) ,
                    )
                )
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
  }

  @override
  bool get wantKeepAlive => true;
}
