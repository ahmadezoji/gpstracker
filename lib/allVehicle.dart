import 'dart:core';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:cargpstracker/main.dart';
import 'package:cargpstracker/mainTabScreens/addVehicle.dart';
import 'package:cargpstracker/mainTabScreens/updateVehicle.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

import 'models/device.dart';

class myAllVehicle extends StatefulWidget {
  const myAllVehicle(
      {Key? key,
      required this.selectedDevice,
      required this.selectedDeviceIndex,
      required this.direction})
      : super(key: key);
  final Function selectedDevice;
  final int selectedDeviceIndex;
  final VehicleTooltipDirection direction;

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
  late int selectedDeviceIndex = widget.selectedDeviceIndex;
  late int selectedBaloonIndex = -2;
  late myUser? currentUser = StoreProvider.of<AppState>(context).state.user;

  @override
  void initState() {
    super.initState();
    print(context);
    selectedDeviceIndex = widget.selectedDeviceIndex;
    selectedBaloonIndex = -2;
  }

  void _deleteVehicle(Device device) async {
    try {
      // bool? result = await deleteDevice(device);
      // Fluttertoast.showToast(msg: 'delete device is $result');
      // StoreProvider.of<AppState>(context)
      //     .dispatch(DeleteDeviceAction(input: device));
      setState(() {
        selectedBaloonIndex = -2;
      });
      // if (result!) Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: 'unsuccessful process');
    }
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
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) => Container(
        padding: EdgeInsets.all(5),
        height: 60,
        child: Row(
          children: [
            if (state.devices.length > 0)
              Expanded(
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  // padding: const EdgeInsets.all(8),
                  itemCount: state.devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _vehicleIcon(context, state.devices[index], index);
                  },
                ),
              ),
            _vehicleIcon(context, null, -1),
          ],
        ),
      ),
    );
  }

  Widget _vehicleIcon(BuildContext context, Device? device, int deviceIndex) {
    return SimpleTooltip(
        ballonPadding: EdgeInsets.zero,
        borderColor: Colors.transparent,
        tooltipDirection: widget.direction==VehicleTooltipDirection.UP ? TooltipDirection.up : TooltipDirection.down,
        child: GestureDetector(
          onLongPress: () {
            setState(() {
              selectedBaloonIndex = selectedBaloonIndex == -2 ? deviceIndex : -2;
            });
          },
          onTap: () {
            if (deviceIndex == -1) {
              setState(() {
                selectedBaloonIndex = -2;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddVehicle(currentUser: currentUser!),
                      fullscreenDialog: false));
            } else {
              setState(() {
                selectedDeviceIndex = deviceIndex;
                selectedBaloonIndex = -2;
              });
              Fluttertoast.showToast(msg: device!.title);
              widget.selectedDevice(device);
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
                        getTypeAsset(device!.type),
                        height: 21,
                        width: 21,
                        color: Colors.black,
                      ),
                      Text(
                        device.title.length > 6
                            ? device.title.substring(0, 6) + "..."
                            : device.title,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
          ),
        ),
        content: Container(
          height: 50,
          width: 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => showAlertDialog(context, _deleteVehicle),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (deviceIndex != 0)
                      Text(
                        "ballon-remove".tr,
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    Icon(
                      Icons.close,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UpdateVehicle(currentDeveice: device!),
                        fullscreenDialog: false),
                  );
                  setState(() {
                    selectedBaloonIndex = -2;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (deviceIndex != 0)
                      Text(
                        "ballon-edit".tr,
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    Icon(
                      Icons.edit,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        show: selectedBaloonIndex == deviceIndex);
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
