import 'dart:core';

import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key, required this.currentUser}) : super(key: key);
  final myUser currentUser;

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with TickerProviderStateMixin {
  late AnimationController controller;
  late Device? currentDevice;

  static const platform = const MethodChannel("platfrom.channel.message/info");

  bool loading = false;
  bool offlineMode = false;

  @override
  void initState() {
    super.initState();
  }

  void _onchangedOffline(bool status) {}

  @override
  void dispose() {
    super.dispose();
  }

  void applyChanges() async {
    try {} catch (e) {
      print('errpor = $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("setting".tr),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(30),
                      child:  ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Icon(Icons.language),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("app-language".tr),
                              ],
                            ),
                          ),
                          Divider(height: 5, thickness: 2),
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Icon(Icons.add_alert_sharp),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("app-notification".tr)
                              ],
                            ),
                          ),
                          Divider(height: 5, thickness: 2),
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Icon(Icons.privacy_tip),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("app-privacy".tr)
                              ],
                            ),
                          ),
                          Divider(height: 5, thickness: 2),
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Icon(Icons.pie_chart),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("app-data-storage".tr)
                              ],
                            ),
                          ),
                          Divider(height: 5, thickness: 2),
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Icon(Icons.add_task),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("app-QA".tr)
                              ],
                            ),
                          )
                        ],
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
                          fixedSize: Size(300, 50)),
                    ),
                  ),
                ],
              )
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
        Switch(
          value: offlineMode,
          onChanged: (value) {
            setState(() {
              offlineMode = value;
              print(offlineMode);
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
      ],
    );
  }
}
