import 'dart:convert' as convert;

import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/models/config.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/user.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Setting2 extends StatefulWidget {
  const Setting2(
      {Key? key, required this.currentUser, required this.userDevices})
      : super(key: key);
  final List<Device> userDevices;
  final User currentUser;
  @override
  _Setting2State createState() => _Setting2State();
}

class _Setting2State extends State<Setting2> with TickerProviderStateMixin {
  late AnimationController controller;
  late String valueChoose;
  List listItem = ["option1", 'option2'];
  late Device currentDevice;
  late Config currentDeviceConfig = Config(
      device_id: "",
      language: "",
      timezone: "",
      intervalTime: 1,
      staticTime: 1,
      speed_alarm: 20,
      fence: "",
      userPhoneNum: "",
      apn_name: "default",
      apn_user: "default",
      apn_pass: "default",
      alarming_method: 1);
  List<String> devicesListSerials = [];
  static const platform = const MethodChannel("platfrom.channel.message/info");
  int languageIndex = 0;
  String serial = '';
  String intervalTime = '';
  String staticTime = '';
  String adminNum = '';
  String timezone = '';
  String language = '';
  String speedAlarm = '';
  String fence = '';
  String apn_name = '';
  String apn_user = '';
  String apn_pass = '';
  String alarming_method = '';

  bool loading = false;

  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'فارسی', 'locale': Locale('fa', 'IR')},
  ];

  @override
  void initState() {
    super.initState();
    getCurrentDevice().then((value) => getCurrentDeviceConfig(value));
  }

  Future<Config> getCurrentDeviceConfig(Device device) async {
    currentDeviceConfig = (await getConfig(device))!;
    print(currentDeviceConfig);
    return currentDeviceConfig;
  }

  Future<Device> getCurrentDevice() async {
    if (widget.userDevices.length > 0) {
      setState(() {
        currentDevice = widget.userDevices[0];
      });
    }

    print('currentDevice = $currentDevice');
    return currentDevice;
  }

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void applyChanges() async {
    Config newconfig = Config(
        device_id: currentDeviceConfig.device_id,
        language: language,
        timezone: timezone,
        intervalTime: int.parse(intervalTime),
        staticTime: int.parse(staticTime),
        speed_alarm: int.parse(speedAlarm),
        fence: fence,
        userPhoneNum: currentDeviceConfig.userPhoneNum,
        apn_name: apn_name,
        apn_user: apn_user,
        apn_pass: apn_pass,
        alarming_method: int.parse(alarming_method));

    print(newconfig);
  }

  Widget buildRecord(
      String lable, String hint, String value, Function onchanged) {
    print(hint);
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
          filled: true,
          label: Text(lable),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      onChanged: (value) => {onchanged(value)},
    );
  }

  void _onSelectedIntervalTime(String value) {
    setState(() {
      intervalTime = value;
    });
  }

  void _onSelectedStaticTime(String value) {
    setState(() {
      staticTime = value;
    });
  }

  void _onSelectedLanguage(String value) {
    setState(() {
      language = value;
    });
  }

  void _onSelectedTimeZone(String value) {
    setState(() {
      timezone = value;
    });
  }

  void _onSelectedSpeedAlarm(String value) {
    setState(() {
      speedAlarm = value;
    });
  }

  void _onSelectedFence(String value) {
    setState(() {
      fence = value;
    });
  }

  void _onSelectedApnName(String value) {
    setState(() {
      apn_name = value;
    });
  }

  void _onSelectedApnUser(String value) {
    setState(() {
      apn_user = value;
    });
  }

  void _onSelectedApnPass(String value) {
    setState(() {
      apn_pass = value;
    });
  }

  void _onSelectedAlarmMethod(String value) {
    setState(() {
      alarming_method = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        body: SingleChildScrollView(
            child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "setting".tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    padding: EdgeInsets.all(30),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        DropdownButton<Device>(
                          value: currentDevice,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          underline: Container(
                            height: 2,
                          ),
                          onChanged: (Device? device) {
                            getCurrentDeviceConfig(device!);
                          },
                          items: widget.userDevices
                              .map<DropdownMenuItem<Device>>((Device value) {
                            return DropdownMenuItem<Device>(
                              value: value,
                              child: Text(value.serial),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        buildRecord(
                          "language",
                          "en/fa",
                          currentDeviceConfig.language,
                          _onSelectedLanguage,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        buildRecord(
                          "Time zone",
                          "tehran",
                          currentDeviceConfig.timezone,
                          _onSelectedTimeZone,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        buildRecord(
                            "Interval time",
                            "1-59 seconds",
                            currentDeviceConfig.intervalTime.toString(),
                            _onSelectedIntervalTime),
                        SizedBox(
                          height: 15,
                        ),
                        buildRecord(
                            "Static time",
                            "1-59 minutes",
                            currentDeviceConfig.staticTime.toString(),
                            _onSelectedStaticTime),
                        SizedBox(
                          height: 15,
                        ),
                        buildRecord(
                            "Speed alarm",
                            "60-220 km/h",
                            currentDeviceConfig.speed_alarm.toString(),
                            _onSelectedSpeedAlarm),
                        SizedBox(
                          height: 15,
                        ),
                        buildRecord(
                          "Fence",
                          "Null",
                          currentDeviceConfig.fence,
                          _onSelectedFence,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        buildRecord(
                          "Apn name",
                          "Null",
                          currentDeviceConfig.apn_name,
                          _onSelectedApnName,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        buildRecord(
                          "Apn user",
                          "Null",
                          currentDeviceConfig.apn_user,
                          _onSelectedApnUser,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        buildRecord(
                          "Apn pass",
                          "Null",
                          currentDeviceConfig.apn_pass,
                          _onSelectedApnPass,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        buildRecord(
                            "Alarming method",
                            "Null",
                            currentDeviceConfig.alarming_method.toString(),
                            _onSelectedAlarmMethod),
                      ],
                    ))
              ]),
              ElevatedButton(
                child: Text(
                  "apply".tr,
                  style: const TextStyle(fontSize: 20),
                ),
                onPressed: () => applyChanges(),
                style: ElevatedButton.styleFrom(fixedSize: const Size(300, 50)),
              )
            ],
          ),
        )),
      );
    });
  }
}
