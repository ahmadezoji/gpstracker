// import 'package:cargpstracker/mainTabScreens/qrScanner.dart';
import 'dart:convert';
import 'dart:core';

import 'package:cargpstracker/mainTabScreens/register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key, required this.code, required this.userPhone})
      : super(key: key);
  final String code;
  final String userPhone;
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage>
    with AutomaticKeepAliveClientMixin<OtpPage> {
  late String code;
  @override
  void initState() {
    super.initState();
    // print('initState Live');
    // devices.add(Text('asdsd'));
  }

  void addUser() async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://130.185.77.83:4680/addUser/'));
      request.fields.addAll({'phone': widget.userPhone});
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final json = jsonDecode(responseString);
        print(json);
        if (json != null) {
          Fluttertoast.showToast(msg: "add-user-msg".tr);
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('phone', widget.userPhone).then((bool success) async {
            print(true);
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => RegisterPage(userPhone: widget.userPhone),
                  fullscreenDialog: false));
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle kStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w900,
    );

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
                onChanged: (value) => setState(() {
                  code = value;
                  if (code == widget.code) {
                    addUser();
                  }
                }),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "code".tr,
                ),
              ),
            ),
            // Container(
            //   height: 50,
            //   width: 250,
            //   decoration: BoxDecoration(
            //       color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            //   child: TextButton(
            //     onPressed: () async {},
            //     child: Text(
            //       "Save".tr,
            //       style: TextStyle(color: Colors.white, fontSize: 20),
            //     ),
            //   ),
            // ),
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
