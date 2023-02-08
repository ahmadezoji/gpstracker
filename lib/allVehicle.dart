import 'dart:core';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:cargpstracker/mainTabScreens/addVehicle.dart';
import 'package:cargpstracker/models/user.dart';
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
      required this.currentUser,
      required this.userDevices})
      : super(key: key);
  final List<Device> userDevices;
  final bool userLogined;
  final User currentUser;
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
    selectedDeviceIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 55,
      child: Row(
        children: [
          if (widget.userDevices.length > 0)
            Expanded(
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                // padding: const EdgeInsets.all(8),
                itemCount: widget.userDevices.length,
                itemBuilder: (BuildContext context, int index) {
                  return _vehicleIcon(context, index);
                },
              ),
            ),
          _vehicleIcon(context, -1)
        ],
      ),
    );
  }

  Widget _vehicleIcon(BuildContext context, int deviceIndex) {
    return GestureDetector(
      onTap: () {
        if (deviceIndex == -1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddVehicle(currentUser: widget.currentUser),
                  fullscreenDialog: false));
        } else {
          setState(() {
            selectedDeviceIndex = deviceIndex;
          });
          Fluttertoast.showToast(msg: widget.userDevices[deviceIndex].title);
          widget.selectedDevice(selectedDeviceIndex);
        }
      },
      child: Container(
        width: 55,
        height: 55,
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 2, right: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: selectedDeviceIndex == deviceIndex
              ? selectedVehicleCardColor
              : vehicleCardColor,
        ),
        child: deviceIndex == -1
            ? Center(
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 35,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    getTypeAsset(widget.userDevices[deviceIndex].type),
                    height: 21,
                    width: 21,
                    color: Colors.black,
                  ),
                  Text(
                    widget.userDevices[deviceIndex].title.length > 6
                        ? widget.userDevices[deviceIndex].title
                                .substring(0, 6) +
                            "..."
                        : widget.userDevices[deviceIndex].title,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
      ),
    );
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