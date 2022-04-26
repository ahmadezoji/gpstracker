import 'dart:core';

import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/maplive.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with AutomaticKeepAliveClientMixin<StartPage> {
  @override
  void initState() {
    super.initState();
    // print('initState Live');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 200, bottom: 0, left: 10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(100, 50),
                primary: Colors.blue, // background
                onPrimary: Colors.white, // foreground
                padding: EdgeInsets.only(top: 5),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text('ورود'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(100, 50),
                primary: Colors.blue, // background
                onPrimary: Colors.white, // foreground
                padding: EdgeInsets.only(top: 5),
              ),
              onPressed: () {},
              child: Text('نسخه آزمایش'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
