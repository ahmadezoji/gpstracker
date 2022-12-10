// import 'package:cargpstracker/mainTabScreens/qrScanner.dart';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.userPhone}) : super(key: key);
  final String userPhone;
  @override
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with AutomaticKeepAliveClientMixin<RegisterPage> {
  late String serial;
  late String deviceSimNum;

  @override
  void initState() {
    super.initState();
    // print('initState Live');
    // devices.add(Text('asdsd'));
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle kStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w900,
    );

    void addDevice() async {
      try {
        var request = http.MultipartRequest(
            'POST', Uri.parse('https://130.185.77.83:4680/addDevice/'));
        request.fields.addAll({
          'serial': serial,
          'userNum': widget.userPhone,
          'deviceSimNum': deviceSimNum
        });

        http.StreamedResponse response = await request.send();
        print(response.statusCode);
        if (response.statusCode == 200) {
          final responseData = await response.stream.toBytes();
          final responseString = String.fromCharCodes(responseData);
          print(responseString);
          final json = jsonDecode(responseString);
          // if (json != null) {
          //   Fluttertoast.showToast(msg: "add-user-msg".tr);
          //   Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //           builder: (_) => HomePage(), fullscreenDialog: false));
          // }
        } else {
          print(response.reasonPhrase);
        }
      } catch (error) {}

      //  Navigator.push(
      // context, MaterialPageRoute(builder: (_) => HomePage()));
    }

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
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() {
                        serial = value;
                      }),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "device".tr,
                          hintText: "device-serial".tr),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() {
                        deviceSimNum = value;
                      }),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "device-sim-num".tr,
                          hintText: "device-sim-num".tr),
                    ),
                  ],
                )),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  addDevice();
                },
                child: Text(
                  "Save".tr,
                  style: TextStyle(color: Colors.white, fontSize: 20),
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
                  _navigateAndDisplaySelection(context);
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

  void _navigateAndDisplaySelection(BuildContext context) async {
    bool _debugLocked =
        false; // used to prevent re-entrant calls to push, pop, and friends
    assert(!_debugLocked);
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) =>  QrScannerPage()),
    // );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text('$result')));
  }

  @override
  bool get wantKeepAlive => true;
}
