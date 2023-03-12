import 'dart:core';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'models/device.dart';

class MyBottomDrawer extends StatefulWidget {
  const MyBottomDrawer(
      {Key? key,
      required this.selectedDevice,
      required this.userLogined,
      required this.userDevices})
      : super(key: key);
  final List<Device> userDevices;
  final bool userLogined;
  final Function selectedDevice;
  @override
  _MyBottomDrawerState createState() => _MyBottomDrawerState();
}

class _MyBottomDrawerState extends State<MyBottomDrawer>
    with AutomaticKeepAliveClientMixin<MyBottomDrawer> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  double _headerHeight = 80.0;
  double _bodyHeight = 250.0;
  BottomDrawerController _controller = BottomDrawerController();
  bool drawerOpen = true;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomDrawer(
      key: _key,
      header: _buildBottomDrawerHead(context),
      body: _buildBottomDrawerBody(context),
      headerHeight: _headerHeight,
      drawerHeight: _bodyHeight,
      color: Colors.transparent,
      controller: _controller,
      callback: (val) => {
        //drawer status
        print(val)
      },
      boxShadow: [
        BoxShadow(
          color: Colors.transparent,
          blurRadius: 1,
          spreadRadius: 5,
          offset: const Offset(2, -6), // changes position of shadow
        ),
      ],
    );
  }

  Widget _buildBottomDrawerHead(BuildContext context) {
    late Color fontColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    late Color backColor = Theme.of(context).brightness == Brightness.dark
        ? backNavBarDark
        : backgroundColor;
    // print(_key.currentState!);
    return new Stack(
      children: <Widget>[
        // The containers in the background
        new Column(
          children: <Widget>[
            new Container(
              alignment: Alignment.center,
              height: _headerHeight * 0.3,
              color: Colors.transparent,
            ),
            new Container(
              alignment: Alignment.center,
              height: _headerHeight * 0.7,
              color: backColor,
              child: Text(
                "See All Vehicles",
                style: TextStyle(color: fontColor, fontSize: 14),
              ),
            )
          ],
        ),
        new Container(
          alignment: Alignment.topCenter,
          // padding: new EdgeInsets.only(top: 2),
          child: new Container(
              height: 50.0,
              // width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: new Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: backColor,
                ),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 5),
                child: new Icon(Scaffold.of(context).isDrawerOpen
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up),
              )),
        )
      ],
    );
  }

  Widget _buildBottomDrawerBody(BuildContext context) {
    late double _screenSize = MediaQuery.of(context).size.width;
    late Color fontColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    late Color backColor = Theme.of(context).brightness == Brightness.dark
        ? backNavBarDark
        : backgroundColor;
    return Container(
      width: double.infinity,
      height: _bodyHeight,
      color: backColor,
      child: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        padding: EdgeInsets.all(10),
        crossAxisCount: (_screenSize / 80).round(),
        crossAxisSpacing: 10,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(widget.userDevices.length, (index) {
          return _vehicleIcon(context, widget.userDevices[index]);
        }),
      ),
    );
  }

  Widget _vehicleIcon(BuildContext context, Device device) {
    return Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white),
        child: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  getTypeAsset(device.type),
                  color: Colors.black,
                ),
                Text(
                  device.title,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
              ],
            ),
            onTap: () {
              Fluttertoast.showToast(msg: device.title);
              widget.selectedDevice(device);
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
