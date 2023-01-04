// import 'package:cargpstracker/mainTabScreens/qrScanner.dart';
import 'dart:convert';
import 'dart:core';

import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/user.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({Key? key, required this.currentUser}) : super(key: key);
  final User currentUser;

  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle>
    with AutomaticKeepAliveClientMixin<AddVehicle> {
  late String serial;
  late String deviceSimNum;
  late String title = "my vehicle";
  late String type = "minicar";
  static Map<String, String> devices = {
    "car".tr: 'minicar',
    "motor".tr: "minimotor",
    "truck".tr: "minitruck",
    "bicycle".tr: 'minibicycle',
    "vanet".tr: "minivanet",
  };
  late List<bool> radioValues = [true, false, false, false, false];

  @override
  void initState() {
    super.initState();
    // print('initState Live');
    // devices.add(Text('asdsd'));
  }

  void _addVehicle() async {
    Device dev = Device(
        serial: serial, title: title, simPhone: deviceSimNum, type: type);
    bool? result = await addDevice(dev, widget.currentUser);
    Fluttertoast.showToast(msg: 'add device is $result');
    if (result!) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    late Color fontColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              // Status bar color
              // statusBarColor: statusColor,

              // Status bar brightness (optional)
              // statusBarIconBrightness:
              //     Brightness.dark, // For Android (dark icons)
              // statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
          title: Text("addVehicle".tr),
          // backgroundColor: NabColor, // status bar color
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 50),
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() {
                    serial = value;
                  }),
                  style: TextStyle(color: fontColor),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    filled: true,
                    labelText: "Serial".tr,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() {
                    deviceSimNum = value;
                  }),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    filled: true,
                    hintText: "+98",
                    labelText: "SimCard Number".tr,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: (value) => setState(() {
                    title = value;
                  }),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    filled: true,
                    labelText: "Car Name".tr,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: devices.entries.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 1.0,
                                  color: Colors.black,
                                  strokeAlign: StrokeAlign.inside),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Radio(
                                        value: false,
                                        onChanged: (value) => setState(() {
                                              radioValues[index] = !value!;
                                            }),
                                        groupValue: true),
                                    SvgPicture.asset(
                                      'assets/${devices.values.elementAt(index)}.svg',
                                    ),
                                  ],
                                ),
                                flex: 1,
                              ),
                              Flexible(
                                child: Text(devices.keys.elementAt(index)),
                                flex: 2,
                              )
                            ],
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  child: Text(
                    'Sumbmit',
                    style: const TextStyle(fontSize: 20),
                  ),
                  onPressed: _addVehicle,
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(250, 50)),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
