import 'dart:core';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:cargpstracker/mainTabScreens/addVehicle.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'models/device.dart';

class myAllVehicle extends StatefulWidget {
  const myAllVehicle(
      {Key? key,
      required this.selectedDevice,
      required this.userLogined,
      required this.userDevices})
      : super(key: key);
  final List<Device> userDevices;
  final bool userLogined;
  final Function selectedDevice;
  @override
  _myAllVehicleState createState() => _myAllVehicleState();
}

class _myAllVehicleState extends State<myAllVehicle>
    with AutomaticKeepAliveClientMixin<myAllVehicle> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  double _headerHeight = 80.0;
  double _bodyHeight = 250.0;
  BottomDrawerController _controller = BottomDrawerController();
  bool drawerOpen = true;
  int selectedDeviceIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100.0,
        child: Row(
          children: [
            ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                itemCount: widget.userDevices.length,
                itemBuilder: (BuildContext context, int index) {
                  return _vehicleIcon(context, index);
                }),
            _vehicleIcon(context, -1)
          ],
        ));
  }

  Widget _vehicleIcon(BuildContext context, int deviceIndex) {
    String getTypeAsset(String type) {
      switch (type.toLowerCase()) {
        case "car":
          {
            return "assets/minicar.svg";
          }
          break;

        case "motor":
          {
            return "assets/minimotor.svg";
          }
          break;
        case "truck":
          {
            return "assets/minitruck.svg";
          }
          break;
        default:
          {
            return "assets/minicar.svg";
          }
          break;
      }
    }

    return Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: selectedDeviceIndex == deviceIndex
              ? selectedVehicleCardColor
              : vehicleCardColor,
        ),
        child: deviceIndex == -1
            ? GestureDetector(
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddVehicle(),
                          fullscreenDialog: false));
                })
            : GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      getTypeAsset(widget.userDevices[deviceIndex].type),
                      height: 21,
                      width: 31,
                      color: Colors.black,
                    ),
                    Text(
                      widget.userDevices[deviceIndex].title,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    selectedDeviceIndex = deviceIndex;
                  });
                  Fluttertoast.showToast(
                      msg: widget.userDevices[deviceIndex].title);
                  widget.selectedDevice(selectedDeviceIndex);
                }));
  }

  @override
  bool get wantKeepAlive => true;
}

Widget cardVehicle(String vehicleName, String assetPath) {
  return (Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(9.0),
      decoration: BoxDecoration(
          color: Colors.white70, borderRadius: BorderRadius.circular(8)),
      width: 65,
      height: 65,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [SvgPicture.asset(assetPath), Text(vehicleName)],
      )));
}
