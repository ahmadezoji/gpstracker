import 'dart:convert' as convert;
import 'dart:core';

import 'package:cargpstracker/dialogs/dialogs.dart';
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

class Setting extends StatefulWidget {
  const Setting(
      {Key? key, required this.userDevices, required this.currentUser})
      : super(key: key);

  final List<Device> userDevices;
  final User currentUser;

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with TickerProviderStateMixin {
  late AnimationController controller;
  late Device currentDevice;
  late Config currentDeviceConfig = Config(
      device_id: "",
      language: "farsi",
      timezone: "istanbul",
      intervalTime: 10,
      staticTime: 50,
      speed_alarm: 120,
      fence: "",
      userPhoneNum: "",
      apn_name: "default",
      apn_user: "default",
      apn_pass: "default",
      alarming_method: 1);
  static const platform = const MethodChannel("platfrom.channel.message/info");

  bool loading = false;

  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'فارسی', 'locale': Locale('fa', 'IR')},
  ];
  List<String> deviceLanges = ["english", "farsi"];
  List<String> deviceTimeZones = ["tehran", "istanbul"];
  List<String> deviceIntervals = ["1", "5", "10", "30", "50"];
  List<String> deviceStatics = ["1", "5", "10", "30", "50"];
  List<String> deviceSpeedAlarms = [
    "0",
    "60",
    "70",
    "80",
    "90",
    "100",
    "120",
    "140",
    "160",
    "180",
    "200",
    "220"
  ];
  List<String> deviceFences = ["default", "A"];
  List<String> deviceAPNs = ["default", "A"];
  List<String> deviceAlarmMethods = ["default", "1", "2"];

  String serial = '';
  String intervalTime = "10";
  String staticTime = "50";
  String adminNum = '';
  String timezone = "tehran";
  String language = "english";
  String speedAlarm = "220";
  String fence = 'default';
  String apn_name = 'default';
  String apn_user = 'default';
  String apn_pass = 'default';
  String alarming_method = "1";

  @override
  void initState() {
    super.initState();
    getCurrentDevice().then((value) => getCurrentDeviceConfig(value));
  }

  Future<Config> getCurrentDeviceConfig(Device device) async {
    Config conff = (await getConfig(device))!;
    setState(() {
      currentDeviceConfig = conff;
    });
    print(currentDeviceConfig);
    return currentDeviceConfig;
  }

  Future<Device> getCurrentDevice() async {
    if (widget.userDevices.length > 0) {
      setState(() {
        currentDevice = widget.userDevices[0];
      });
    }

    print('currentDevice = ${currentDevice.serial}');
    return currentDevice;
  }

  onChangedDropDown(Device device) {
    setState(() {
      currentDevice = device;
    });
    getCurrentDeviceConfig(device);
  }

  void _onchangedLanguage(String value) {
    setState(() {
      currentDeviceConfig.language = value;
    });
  }

  void _onchangedTimezone(String value) {
    setState(() {
      currentDeviceConfig.timezone = value;
    });
  }

  void _onchangedIntervalTime(String value) {
    setState(() {
      currentDeviceConfig.intervalTime = int.parse(value);
    });
  }

  void _onchangedStaticTime(String value) {
    setState(() {
      currentDeviceConfig.staticTime = int.parse(value);
    });
  }

  void _onchangedSpeedAlarm(String value) {
    setState(() {
      currentDeviceConfig.speed_alarm = int.parse(value);
    });
  }

  void _onchangedFence(String value) {
    setState(() {
      fence = value;
    });
  }

  void _onchangedApn(String value) {
    setState(() {
      apn_name = value;
    });
  }

  void _onchangedAlarmMethod(String value) {
    setState(() {
      alarming_method = value;
    });
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
    try {
      bool status = (await setConfig(currentDevice, currentDeviceConfig))!;
      if (status)
        Fluttertoast.showToast(msg: 'Config success and start config thread');
      else
        Fluttertoast.showToast(msg: 'Set config failed !!');
    } catch (e) {
      print('errpor = $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(currentDeviceConfig.intervalTime.toString());
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("setting".tr),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => currentDevice == null
              ? Center(
                  child: Text('There is no device to show !!'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: DropdownButton<Device>(
                                  value: currentDevice,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                  ),
                                  onChanged: (Device? device) {
                                    onChangedDropDown(device!);
                                  },
                                  items: widget.userDevices
                                      .map<DropdownMenuItem<Device>>(
                                          (Device value) {
                                    return DropdownMenuItem<Device>(
                                      value: value,
                                      child: Text(value.serial),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              buildDropDown(
                                "device-lang".tr,
                                deviceLanges,
                                currentDeviceConfig.language.toLowerCase(),
                                _onchangedLanguage,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              buildDropDown(
                                "device-timezone".tr,
                                deviceTimeZones,
                                currentDeviceConfig.timezone.toLowerCase(),
                                _onchangedTimezone,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              buildDropDown(
                                "device-interval".tr,
                                deviceIntervals,
                                currentDeviceConfig.intervalTime.toString(),
                                _onchangedIntervalTime,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              buildDropDown(
                                "device-static".tr,
                                deviceStatics,
                                currentDeviceConfig.staticTime.toString(),
                                _onchangedStaticTime,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              buildDropDown(
                                "device-speedAlarm".tr,
                                deviceSpeedAlarms,
                                currentDeviceConfig.speed_alarm.toString(),
                                _onchangedSpeedAlarm,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              buildToggle("Offline Mode","",_onchangedApn),
                              // buildDropDown(
                              //   "device-fence".tr,
                              //   deviceFences,
                              //   fence,
                              //   _onchangedFence,
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // buildDropDown(
                              //   "device-apnName".tr,
                              //   deviceAPNs,
                              //   apn_name,
                              //   _onchangedApn,
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // buildDropDown(
                              //   "device-apnUser".tr,
                              //   deviceAPNs,
                              //   apn_user,
                              //   _onchangedApn,
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // buildDropDown(
                              //   "device-apnPass".tr,
                              //   deviceAPNs,
                              //   apn_pass,
                              //   _onchangedApn,
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // buildDropDown(
                              //   "device-speedAlarmMethod".tr,
                              //   deviceAlarmMethods,
                              //   currentDeviceConfig.alarming_method.toString(),
                              //   _onchangedAlarmMethod,
                              // ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth,
                      child: ElevatedButton(
                        child: Text(
                          "apply".tr,
                          style: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () => applyChanges(),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(300, 50)),
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  Row buildToggle(
      String lable, String selectValue, Function onChangedDropDown) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lable,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        ToggleButtons(
          isSelected: [true, false],
          onPressed: (int index) {},
          children: const <Widget>[
            Icon(Icons.cloud),
            Icon(Icons.cloud_off),
          ],
        ),
      ],
    );
  }

  Row buildDropDown(String lable, List<String> values, String selectValue,
      Function onChangedDropDown) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lable,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1)),
          // dropdown below..
          child: DropdownButton<String>(
            value: selectValue,
            onChanged: (value) {
              onChangedDropDown(value);
            },
            items: values
                .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 12),
                          ),
                        ))
                .toList(),
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 32,
            underline: SizedBox(),
          ),
        )
      ],
    );
  }
}
