import 'dart:math';

import 'package:cargpstracker/maplive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:flutter/services.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late String valueChoose;
  List listItem = ["option1", 'option2'];
  static const platform = const MethodChannel("platfrom.channel.message/info");
  int languageIndex = 0;
  bool valNotify = false;
  String serial = '027028362416';
  String interval = '1-60s';
  String static = '1-60m';
  String adminNum = '09127060772';
  String timezone = 'tehran';
  String language = 'english';
  String speedAlarm = '60-220 km/h';
  String notifyType = '2';

  onChangeFunction(bool newValue) {
    setState(() {
      valNotify = newValue;
    });
  }

  onChangeTextSerial(String newValue) {
    setState(() {
      serial = newValue;
    });
  }

  onChangeTextInterval(String newValue) {
    setState(() {
      interval = newValue;
    });
  }

  onChangeTextStatic(String newValue) {
    setState(() {
      static = newValue;
    });
  }

  onChangeTextAdminNum(String newValue) {
    setState(() {
      adminNum = newValue;
    });
  }

  onChangeTextSpeedAlarm(String newValue) {
    setState(() {
      speedAlarm = newValue;
    });
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  void fetch() async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://185.208.175.202:4680/getConfig/'));
      request.fields.addAll({'serial': serial});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final json = convert.jsonDecode(responseString);
        print(json);
        setState(() {
          serial = json["device_id_id"].toString();
          interval = json["interval"].toString();
          static = json["static"].toString();
          timezone = json["timezone"].toString();
          language = json["language"].toString();
          speedAlarm = json["speed_alarm"].toString();
          adminNum = json["admin_num"].toString();
        });

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('serial', serial).then((bool success) {
          print(success);
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error add project $error');
    }
  }

  Future<Null> sendSms() async {
    print("SendSMS");
    try {
      final String result = await platform.invokeMethod(
          'send', <String, dynamic>{
        "phone": "09127060772",
        "msg": "Hello! I'm sent programatically."
      }); //Replace a 'X' with 10 digit phone number
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  Future<void> applyChanges() async {
    sendSms();
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://185.208.175.202:4680/setConfig/'));
    request.fields.addAll({
      'serial': serial,
      'timezone': timezone,
      'language': language,
      'speed': speedAlarm,
      'notification': notifyType,
      'apnName': 'test',
      'apnUser': 'user',
      'apnPass': '123',
      'number': adminNum,
      'fence': '',
      'interval': interval,
      'static': static
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('serial', serial).then((bool success) async {
        print(serial);
        print(await response.stream.bytesToString());
      });
    } else {
      print(response.reasonPhrase);
    }
  }

// buildDeviceOptions(context, 'Device serial', serial),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Column(
            children: [
              dropdown(),
              buildDeviceOptions(
                  context, 'Interval', interval, onChangeTextInterval),
              buildDeviceOptions(
                  context, 'Statics', static, onChangeTextStatic),
              buildDeviceOptions(
                  context, 'Alarm number', adminNum, onChangeTextAdminNum),
              buildTableOptions(context, 'Time Zone', 'istanbul', 'tehran'),
              buildTableOptions(context, 'Language', 'english', 'persian'),
              buildSwitchOptions('Fence Config', valNotify, onChangeFunction),
              buildDeviceOptions(
                  context, 'Alarm Speed', speedAlarm, onChangeTextSpeedAlarm),
            ],
          ),
          Container(
            child: TextButton(
              child: Text(
                'Apply',
                style: TextStyle(fontSize: 20.0),
              ),
              // color: Colors.blueAccent,
              // textColor: Colors.white,
              onPressed: () {
                applyChanges();
              },
            ),
          ),

          // SizedBox(
          //   height: 10,
          // ),
          // Row(
          //   children: const [
          //     Icon(
          //       Icons.device_hub,
          //       color: Colors.black,
          //     ),
          //     SizedBox(
          //       width: 10,
          //     ),
          //     Text('Device',
          //         style: TextStyle(
          //             fontSize: 20,
          //             color: Colors.black,
          //             fontWeight: FontWeight.bold))
          //   ],
          // ),
          // SizedBox(
          //   height: 5,
          // ),
          // Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.all(Radius.circular(20)),
          //     ),
          //     child: Expanded(
          //         child: Column(
          //           children: [
          //             dropdown(),
          //             buildDeviceOptions(context, 'Interval', interval,
          //                 onChangeTextInterval),
          //             buildDeviceOptions(
          //                 context, 'Statics', static, onChangeTextStatic),
          //             buildDeviceOptions(
          //                 context, 'Alarm number', adminNum,
          //                 onChangeTextAdminNum),
          //             buildTableOptions(
          //                 context, 'Time Zone', 'istanbul', 'tehran'),
          //             buildTableOptions(
          //                 context, 'Language', 'english', 'persian'),
          //             buildSwitchOptions(
          //                 'Fence Config', valNotify, onChangeFunction),
          //             buildDeviceOptions(context, 'Alarm Speed', speedAlarm,
          //                 onChangeTextSpeedAlarm),
          //           ],
          //         ))),
          // SizedBox(
          //   height: 40,
          // ),
          // Row(
          //   children: const [
          //     Icon(
          //       Icons.settings_applications,
          //       color: Colors.black,
          //     ),
          //     SizedBox(
          //       width: 10,
          //     ),
          //     Text('Application',
          //         style:
          //         TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          //   ],
          // ),
          // SizedBox(
          //   height: 5,
          // ),
          // Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.all(Radius.circular(20)),
          //     ),
          //     child: Expanded(
          //         child: Column(
          //           children: [
          //             buildDeviceOptions(context, 'Backup days', '5 days',
          //                 onChangeTextSerial)
          //           ],
          //         ))),
        ],
      ),
    ));
  }

  Padding buildSwitchOptions(
      String title, bool value, Function onChangedMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
                activeColor: Colors.blue,
                trackColor: Colors.grey,
                value: value,
                onChanged: (bool newValue) {
                  onChangedMethod(newValue);
                }),
          )
        ],
      ),
    );
  }

  Padding dropdown() {
    return (Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'serial',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            DropdownButton<String>(
              value: serial,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  serial = newValue!;
                });
              },
              items: <String>['027028362416', '027028360584	', '027028356897']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        )));
  }

  GestureDetector buildDeviceOptions(
      BuildContext context, String title, String hint, Function onChagne) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            IntrinsicWidth(
              child: TextField(
                onChanged: (value) {
                  onChagne(value);
                },
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: hint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildTableOptions(
      BuildContext context, String title, String option1, String option2) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext cotext) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text(option1), Text(option2)],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        // Navigator.of(context).pop();
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text('Apply'))
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? Icon(
            Icons.check,
            color: Colors.blue,
          )
        : Icon(null);
  }

  void changeLanguage(int index) {
    setState(() {
      languageIndex = index;
    });
  }
}
