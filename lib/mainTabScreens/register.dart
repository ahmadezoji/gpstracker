import 'dart:core';

import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/mainTabScreens/qrScanner.dart';
import 'package:cargpstracker/maplive.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with AutomaticKeepAliveClientMixin<RegisterPage> {
  // ignore: deprecated_member_use
  // late List<Text> devices = new List<Text>();

  @override
  void initState() {
    super.initState();
    // print('initState Live');
    // devices.add(Text('asdsd'));
  }

  void loadDeviceLocally() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Fetch and decode data
    // final String devicesString = await prefs.getString('devices_key');

    // final List<Device> devices = Device.decode(devicesString);
  }

  void saveDeviceLocally() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Encode and store data in SharedPreferences
    // final String encodedData = Device.encode([
    //   Device(
    //       serial: '027028362416', title: 'farshad', userPhone: '09127060772'),
    // ]);
    //
    // await prefs.setString('devices_key', encodedData);
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle kStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w900,
    );

    // final List<Text> devices = [
    //   Text('Toyota'),
    //   Text('VolksWagen'),
    //   Text('Nissan'),
    //   Text('Renault'),
    //   Text('Mercedes'),
    //   Text('BMW')
    // ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Register Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 200, bottom: 10),
              // padding: EdgeInsets.symmetric(horizontal: 60),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'دستگاه',
                    hintText: 'شماره سریال'),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  // final prefs = await SharedPreferences.getInstance();
                  // prefs
                  //     .setString('devices', devices.toString())
                  //     .then((bool success) {
                  //   print(success);
                  // });
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                },
                child: Text(
                  'ذخیره',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 100,
              height: 100,
              // decoration: BoxDecoration(
              //     border: Border.all(),
              //     borderRadius: BorderRadius.circular(2.0)),
              child: IconButton(
                icon: Icon(Icons.qr_code, size: 46),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => QrScannerPage()));
                },
              ),
              // DefaultTextStyle(
              //   style: kStyle,
              //   child: Column(
              //     children: devices,
              //   ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
