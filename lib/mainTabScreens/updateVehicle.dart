// import 'package:cargpstracker/mainTabScreens/qrScanner.dart';
import 'dart:core';

import 'package:cargpstracker/allVehicle.dart';
import 'package:cargpstracker/main.dart';
import 'package:cargpstracker/mainTabScreens/simCardManagment.dart';
import 'package:cargpstracker/models/config.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UpdateVehicle extends StatefulWidget {
  const UpdateVehicle({
    Key? key,
    required this.currentDeveice,
  }) : super(key: key);
  final Device currentDeveice;

  @override
  _UpdateVehicleState createState() => _UpdateVehicleState();
}

class _UpdateVehicleState extends State<UpdateVehicle>
    with
        AutomaticKeepAliveClientMixin<UpdateVehicle>,
        TickerProviderStateMixin {
  static Map<String, String> devices = {
    "car".tr: 'minicar',
    "motor".tr: "minimotor",
    "truck".tr: "minitruck",
    "bicycle".tr: 'minibicycle',
    "vanet".tr: "minivanet",
  };
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
  late List<bool> radioValues = [true, false, false, false, false];
  late String selectedValue;
  late TabController _nestedTabController;
  late Device _currentDevice = widget.currentDeveice;
  late int selectedIndex =
      StoreProvider.of<AppState>(context).state.devices.indexOf(_currentDevice);

  @override
  void initState() {
    super.initState();
    _nestedTabController = TabController(length: 2, vsync: this);
    selectedValue = devices.keys.firstWhere(
        (k) => devices[k] == _currentDevice.type,
        orElse: () => "null");
    getCurrentDeviceConfig(_currentDevice);
  }

  void _updateVehicle() async {
    try {
      bool status = (await setConfig(_currentDevice, currentDeviceConfig))!;
      if (status)
        Fluttertoast.showToast(msg: 'Config success and start config thread');
      else
        Fluttertoast.showToast(msg: 'Set config failed !!');
      Device dev = Device(
          serial: _currentDevice.serial,
          title: _currentDevice.title,
          simPhone: _currentDevice.simPhone,
          type: devices[selectedValue]!);
      bool? result = await updateDevice(dev);
      if (result!) {
        // (viewModel as _ViewModel).updateItemToList(dev);
        StoreProvider.of<AppState>(context).dispatch(UpdateAction(input: dev));
        Navigator.canPop(context);
      }
      Fluttertoast.showToast(msg: 'update device is $result');
      if (result) Navigator.pop(context);
    } catch (error) {
      print(error);
    }
  }

  void _deleteVehicle() async {
    try {
      bool? result = await deleteDevice(_currentDevice);
      Fluttertoast.showToast(msg: 'delete device is $result');
      StoreProvider.of<AppState>(context)
          .dispatch(DeleteAction(input: _currentDevice));
      if (result!) Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: 'unsuccessful process');
    }
  }

  Future<void> _onSelectedDevice(Device device) async {
    String value = devices.keys
        .firstWhere((k) => devices[k] == device.type, orElse: () => "null");
    setState(() {
      selectedValue = value;
      _currentDevice = device;
    });
    getCurrentDeviceConfig(device);
  }

  Future<Config> getCurrentDeviceConfig(Device device) async {
    Config conff = (await getConfig(device))!;
    setState(() {
      currentDeviceConfig = conff;
    });
    print(currentDeviceConfig);
    return currentDeviceConfig;
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

  @override
  Widget build(BuildContext context) {
    late Color fontColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text("updateVehicle".tr),
            actions: [
              Container(
                padding: EdgeInsets.only(right: 10, left: 10),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => showAlertDialog(context, _deleteVehicle),
                ),
              )
            ],
            // backgroundColor: NabColor, // status bar color
          ),
          body: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, viewModel) => LayoutBuilder(
                  builder: (context, constraints) => Container(
                        alignment: AlignmentDirectional.center,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                child: myAllVehicle(
                                  selectedDevice: _onSelectedDevice,
                                  selectedDeviceIndex: selectedIndex,
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(20),
                                child: ListView(
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      child: TabBar(
                                        controller: _nestedTabController,
                                        indicatorColor: Colors.orange,
                                        labelColor: Colors.orange,
                                        unselectedLabelColor: Colors.black54,
                                        isScrollable: true,
                                        tabs: <Widget>[
                                          Tab(
                                            text: "update-device".tr,
                                            icon:
                                                Icon(Icons.phone_android_sharp),
                                          ),
                                          Tab(
                                            text: "update-simcard".tr,
                                            icon: SvgPicture.asset(
                                                "assets/simcard-icon.svg"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Container(
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(width: 1,color: Colors.black),
                                          //     borderRadius: BorderRadius.circular(6)
                                          //
                                          // ),
                                          height: constraints.maxHeight,
                                          margin: const EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: TabBarView(
                                            controller: _nestedTabController,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: SingleChildScrollView(
                                                  child: buildUpdateVehicleView(
                                                      context, _currentDevice),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: SimCardPage
                                                    .buildSimCardView(
                                                        _currentDevice
                                                            .simPhone),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              )),
                              SizedBox(
                                width: constraints.maxWidth,
                                child: ElevatedButton(
                                  child: Text(
                                    "apply".tr,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () => _updateVehicle(),
                                  style: ElevatedButton.styleFrom(
                                      fixedSize:
                                          Size(constraints.maxWidth, 50)),
                                ),
                              ),
                            ]),
                      ))));
    });
  }

  Widget buildUpdateVehicleView(BuildContext context, Device device) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(15),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TextFormField(
              controller: TextEditingController(text: device.simPhone),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {
                device.simPhone = value;
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
              controller: TextEditingController(text: device.title),
              onChanged: (value) => setState(() {
                device.title = value;
              }),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(6),
                ),
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
                              // strokeAlign: StrokeAlign.inside,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  devices.keys.elementAt(index) == selectedValue
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
                              child:
                                  Text('${devices.keys.elementAt(index)}'.tr),
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
          ],
        ));
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
