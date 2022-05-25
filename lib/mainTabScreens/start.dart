import 'dart:core';

import 'package:cargpstracker/mainTabScreens/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with AutomaticKeepAliveClientMixin<StartPage> {
  late String _name = 'befor';

  // static const platform = const MethodChannel("myChannel");
  static const platform = MethodChannel('com.next.cargpstracker/sendMsg');

  @override
  void initState() {
    super.initState();
    // print('initState Live');
    // platform.setMethodCallHandler(nativeMethodCallHandler);
    loadData();
  }

  // Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
  //   print('Native call!');
  //   switch (methodCall.method) {
  //     case "methodNameItz" :
  //       return "This data from flutter.....";
  //       break;
  //     default:
  //       return "Nothing";
  //       break;
  //   }
  // }
  void loadData() async {
    // String dsd = await fetch();
    // setState(() {
    //   _name = dsd;
    // });
  }

  Future<Null> sendSms() async {
    print("SendSMS");
    try {
      final String result = await platform.invokeMethod(
          'send', <String, dynamic>{
        "phone": "09195835135",
        "msg": "Hello! I'm sent programatically."
      }); //Replace a 'X' with 10 digit phone number
      print(result);
    } on PlatformException {
      print('مشکل');
    }
  }

  // Future<String> fetch() async {
  //   try {
  //     var request = http.MultipartRequest(
  //         'POST', Uri.parse('https://130.185.77.83:4680/live/'));
  //     request.fields.addAll({'serial': '027028356897'});
  //     request.headers.addAll({'Access-Control-Allow-Origin': '*'});
  //     http.StreamedResponse response = await request.send();
  //
  //     return "ok";
  //   } catch (error) {
  //     // print('Error add project $error');
  //     return "error";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 100),
                  primary: Colors.blue, // background
                  onPrimary: Colors.white, // foreground
                  padding: EdgeInsets.only(top: 5),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text("Login".tr),
              ),
              SizedBox(
                height: 130,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 100),
                  primary: Colors.blue, // background
                  onPrimary: Colors.white, // foreground
                  padding: EdgeInsets.only(top: 5),
                ),
                onPressed: () {
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text("Training".tr),
              ),
            ],
          ),
        ));

    // return Container(
    //   color: Colors.white,
    //   alignment: Alignment.center,
    //   margin: const EdgeInsets.only(top: 200, bottom: 0, left: 10),
    //   child: Column(
    //     children: [
    //       Container(
    //         margin: const EdgeInsets.only(bottom: 100),
    //         child: ElevatedButton(
    //           style: ElevatedButton.styleFrom(
    //             fixedSize: Size(200, 100),
    //             primary: Colors.blue, // background
    //             onPrimary: Colors.white, // foreground
    //             padding: EdgeInsets.only(top: 5),
    //           ),
    //           onPressed: () {
    //             Navigator.pushReplacement(context,
    //                 MaterialPageRoute(builder: (context) => LoginPage()));
    //           },
    //           child: Text("Login".tr),
    //         ),
    //       ),
    //       Container(
    //         margin: const EdgeInsets.only(bottom: 10),
    //         child: ElevatedButton(
    //           style: ElevatedButton.styleFrom(
    //             fixedSize: Size(200, 100),
    //             primary: Colors.blue, // background
    //             onPrimary: Colors.white, // foreground
    //             padding: EdgeInsets.only(top: 5),
    //           ),
    //           onPressed: () { sendSms();},
    //           child: Text("Training".tr),
    //         ),
    //       ),
    //       // Container(
    //       //   margin: const EdgeInsets.only(bottom: 10),
    //       //   child: Text(
    //       //     'Hello, $_name',
    //       //     textAlign: TextAlign.center,
    //       //     overflow: TextOverflow.ellipsis,
    //       //     style: const TextStyle(fontWeight: FontWeight.bold),
    //       //   ),
    //       // ),
    //     ],
    //   ),
    // );
  }

  @override
  bool get wantKeepAlive => true;
}
