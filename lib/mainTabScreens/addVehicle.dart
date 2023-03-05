// import 'package:cargpstracker/mainTabScreens/qrScanner.dart';
import 'dart:core';

import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/main.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class _ViewModel {
  final AddDevice addItemToList;
  _ViewModel({required this.addItemToList});
}

class AddVehicle extends StatefulWidget {
  const AddVehicle({Key? key, required this.currentUser}) : super(key: key);
  final myUser currentUser;
  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle>
    with AutomaticKeepAliveClientMixin<AddVehicle> {
  late String serial;
  late String deviceSimNum;
  late String title = "my vehicle";
  late String type = "minicar";
  final String prefix = "+98";
  static Map<String, String> devices = {
    "car".tr: 'minicar',
    "motor".tr: "minimotor",
    "truck".tr: "minitruck",
    "bicycle".tr: 'minibicycle',
    "vanet".tr: "minivanet",
  };
  late List<bool> radioValues = [true, false, false, false, false];
  late int selectedValue = 0;

  @override
  void initState() {
    super.initState();
    // print('initState Live');
    // devices.add(Text('asdsd'));
  }

  void _addVehicle(Object viewModel) async {
    type = devices.values.elementAt(selectedValue).toString();
    Device dev = Device(
        serial: serial,
        title: title,
        simPhone: prefix + deviceSimNum,
        type: type);
    bool? result = await addDevice(dev, widget.currentUser);
    Fluttertoast.showToast(msg: 'add device is $result');
    if (result!) {
      // Navigator.pop(context);
      //add pushreplacment
      // List<Device> devicesList = (await getUserDevice(widget.currentUser))!;
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => new HomePage(
      //           currentUser: widget.currentUser,
      //           userLogined: true,
      //           userDevices: devicesList)),
      // );
      (viewModel as _ViewModel).addItemToList(dev);
      Navigator.of(context).pop();
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
            systemOverlayStyle: const SystemUiOverlayStyle(),
            title: Text("addVehicle".tr),
          ),
          body: StoreConnector<AppState, _ViewModel>(
            converter: (store) => _ViewModel(
              addItemToList: (inputText) => store.dispatch(
                AddAction(input: inputText),
              ),
            ),
            builder: (context, viewModel) => LayoutBuilder(
              builder: (context, constraints) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(20),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
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
                                    selectedValue = index;
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              index == selectedValue
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
                                              '${devices.keys.elementAt(index)}'
                                                  .tr),
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
                            labelText: "device-serial".tr,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset('assets/serialplace.jpg'),
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
                            prefix: Text(prefix),
                            labelText: "device-sim-num".tr,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset('assets/simcardplace.jpg'),
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
                      onPressed: () => _addVehicle(viewModel),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(constraints.maxWidth, 50)),
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }

  @override
  bool get wantKeepAlive => true;
}
