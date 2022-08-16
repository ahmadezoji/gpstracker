import 'dart:convert' as convert;

import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with TickerProviderStateMixin {
  late AnimationController controller;
  late String valueChoose;
  List listItem = ["option1", 'option2'];
  List<Device> devicesList = [];
  List<String> devicesListSerials = [];
  static const platform = const MethodChannel("platfrom.channel.message/info");
  int languageIndex = 0;
  bool valNotify = false;
  String serial = 'None';
  String interval = '1-60s';
  String static = '1-60m';
  String adminNum = '09127060772';
  String timezone = 'tehran';
  String language = 'english';
  String speedAlarm = '60-220 km/h';
  String notifyType = '2';

  bool loading = false;

  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'فارسی', 'locale': Locale('fa', 'IR')},
  ];

  Device? getCurrentDevice(String serial) {
    try {
      if (devicesList.length == 0) return null;
      for (Device dev in devicesList) {
        if (dev.serial == serial) return dev;
      }
    } catch (e) {}
    return null;
  }

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

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
    // fetch();
    getUserDevice();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {});
    controller.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    // ignore: invalid_use_of_protected_member
    // controller.clearListeners();
    // controller.stop(canceled: true);
    super.dispose();
  }

  void getUserDevice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? phone = prefs.getString('phone');
      print(phone);
      // String phone = '09195835135';

      if (phone == null) return;
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://130.185.77.83:4680/getDeviceByUser/'));
      request.fields.addAll({
        'phone': phone,
      });

      http.StreamedResponse response = await request.send();

      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final json = convert.jsonDecode(responseString);

        for (var dev in json) {
          Device device = Device.fromJson(dev);
          devicesList.add(device);
          devicesListSerials.add(device.getSerial());
        }
        serial = devicesListSerials[0];
        // currentDevice = devicesList[0];
        setState(() {
          loading = true;
        });

        // fetch();
        // final prefs = await SharedPreferences.getInstance();
        // prefs.setString('serial', devicesListSerials[0]).then((bool success) {
        //   print(success);
        // });
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {}
  }

  void fetch() async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://130.185.77.83:4680/getConfig/'));
      request.fields.addAll({'serial': serial});

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final json = convert.jsonDecode(responseString);

        setState(() {
          serial = json[0]["device_id_id"].toString();
          interval = json[0]["interval"].toString();
          static = json[0]["static"].toString();
          timezone = json[0]["timezone"].toString();
          language = json[0]["language"].toString();
          speedAlarm = json[0]["speed_alarm"].toString();
          adminNum = json[0]["admin_num"].toString();
        });

        // final prefs = await SharedPreferences.getInstance();
        // prefs.setString('serial', serial).then((bool success) {
        // print(success);
        // });
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
        "phone": "05346403281",
        "msg": "Hello! I'm sent programatically."
      }); //Replace a 'X' with 10 digit phone number
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  Future<void> applyChanges() async {
    // sendSms();
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://130.185.77.83:4680/setConfig/'));
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
      final rec =
          await saveJson('device', Device.toMap(getCurrentDevice(serial)!));
      print('write shared $rec');

      Device device = (await loadJson('device')) as Device;

      print('read shared ${device.toString()}');
    } else {
      print(response.reasonPhrase);
    }
  }

// buildDeviceOptions(context, 'Device serial', serial),
  @override
  Widget build(BuildContext context) {
    if (loading == false) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularProgressIndicator(
            value: controller.value,
            semanticsLabel: 'Linear progress indicator',
          ),
          Center(child: Text('Please wait its loading...'))
        ],
      ));
    } else {
      return Scaffold(
          appBar: AppBar(
          ),
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
                    buildDeviceOptions(context, 'Alarm number', adminNum,
                        onChangeTextAdminNum),
                    buildTableOptions(
                        context, 'Time Zone', 'istanbul', 'tehran'),
                    buildTableOptions(
                        context, 'Language', 'english', 'persian'),
                    buildSwitchOptions(
                        'Fence Config', valNotify, onChangeFunction),
                    buildDeviceOptions(context, 'Alarm Speed', speedAlarm,
                        onChangeTextSpeedAlarm),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "change_lang".tr,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          var locale = Locale('en', 'US');
                          Get.updateLocale(locale);
                        },
                        child: Text('English')),
                    ElevatedButton(
                        onPressed: () {
                          var locale = Locale('fa', 'IR');
                          Get.updateLocale(locale);
                        },
                        child: Text('فارسی')),
                  ],
                ),
                SizedBox(height: 20),
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
                    // color: Colors.blueAccent,
                    // textColor: Colors.white,
                    onPressed: () {
                      applyChanges();
                    },
                  ),
                ),
              ],
            ),
          ));
    }
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
                  fetch();
                });
              },
              items: devicesListSerials
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
