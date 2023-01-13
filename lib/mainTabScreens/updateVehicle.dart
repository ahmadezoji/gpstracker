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

class UpdateVehicle extends StatefulWidget {
  const UpdateVehicle({Key? key, required this.currentDeveice})
      : super(key: key);
  final Device currentDeveice;

  @override
  _UpdateVehicleState createState() => _UpdateVehicleState();
}

class _UpdateVehicleState extends State<UpdateVehicle>
    with AutomaticKeepAliveClientMixin<UpdateVehicle> {
  late String serial;
  late String deviceSimNum = widget.currentDeveice.simPhone;
  late String title = widget.currentDeveice.title;
  static Map<String, String> devices = {
    "car".tr: 'minicar',
    "motor".tr: "minimotor",
    "truck".tr: "minitruck",
    "bicycle".tr: 'minibicycle',
    "vanet".tr: "minivanet",
  };
  late List<bool> radioValues = [true, false, false, false, false];
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = devices.keys.firstWhere(
        (k) => devices[k] == widget.currentDeveice.type,
        orElse: () => "null");
  }

  void _updateVehicle() async {
    try {
      Device dev = Device(
          serial: widget.currentDeveice.serial,
          title: title,
          simPhone: deviceSimNum,
          type: devices[selectedValue]!);
      print(dev.type);
      bool? result = await updateDevice(dev);
      Fluttertoast.showToast(msg: 'update device is $result');
      if (result!) Navigator.pop(context, {"call": true});
    } catch (error) {
      print(error);
    }
  }

  void _deleteVehicle() async {
    try {
      bool? result = await deleteDevice(widget.currentDeveice);
      Fluttertoast.showToast(msg: 'delete device is $result');
      if (result!) Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: 'unsuccessful process');
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
          title: Text("UpdateVehicle".tr),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: GestureDetector(
                onTap: () => showAlertDialog(context, _deleteVehicle),
                child: Icon(
                  Icons.delete,
                  size: 25,
                ),
              ),
            )
          ],
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
                  initialValue: deviceSimNum,
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
                    labelText: "device-sim-num".tr,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: widget.currentDeveice.title,
                  onChanged: (value) => setState(() {
                    title = value;
                  }),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    filled: true,
                    labelText: "device-title".tr,
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
                        return GestureDetector(
                          onTap: () => setState(() {
                            selectedValue = devices.keys.elementAt(index);
                          }),
                          child: Container(
                            height: 30,
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
                                      devices.keys.elementAt(index) ==
                                              selectedValue
                                          ? Icon(Icons.check)
                                          : Icon(Icons.circle_outlined),
                                      SvgPicture.asset(
                                        'assets/${devices.values.elementAt(index)}.svg',
                                      )
                                    ],
                                  ),
                                  flex: 1,
                                ),
                                Flexible(
                                  child: Text(
                                      '${devices.keys.elementAt(index)}'.tr),
                                  flex: 2,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  child: Text(
                    "apply".tr,
                    style: const TextStyle(fontSize: 20),
                  ),
                  onPressed: _updateVehicle,
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(300, 50)),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  showAlertDialog(BuildContext context, Function onDeleteDevice) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("cancel".tr),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget continueButton = TextButton(
      child: Text("apply".tr),
      onPressed: () {
        Navigator.pop(context);
        onDeleteDevice();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("delete_title".tr),
      content: Text("delete_message".tr),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
