import 'dart:core';


import 'package:flutter/material.dart';

class PinCodePage extends StatefulWidget {
  @override
  _PinCodePageState createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage>
    with AutomaticKeepAliveClientMixin<PinCodePage> {
  // ignore: deprecated_member_use
  // late List<Text> devices = new List<Text>();

  @override
  void initState() {
    super.initState();
    // print('initState Live');
    // devices.add(Text('asdsd'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 300, bottom: 10),
          // padding: EdgeInsets.symmetric(horizontal: 60),
          child: TextField(
            keyboardType: TextInputType.visiblePassword,
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
