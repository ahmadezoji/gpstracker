import 'dart:core';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyBottomDrawer extends StatefulWidget {
  const MyBottomDrawer(
      {Key? key,
      required this.speed,
      required this.mile,
      required this.heading,
      required this.date})
      : super(key: key);
  final double speed;
  final double mile;
  final double heading;
  final String date;

  @override
  _MyBottomDrawerState createState() => _MyBottomDrawerState();
}

class _MyBottomDrawerState extends State<MyBottomDrawer>
    with AutomaticKeepAliveClientMixin<MyBottomDrawer> {
  double _headerHeight = 80.0;
  double _bodyHeight = 250.0;
  BottomDrawerController _controller = BottomDrawerController();
  bool drawerOpen = true;
  // List<Map<String, dynamic>> listOMaps = listOStuff
  //     .map((something) => {
  //   "what": something.what,
  //   "the": something.the,
  //   "fiddle": something.fiddle,
  // })
  //     .toList();
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return BottomDrawer(
      header: _buildBottomDrawerHead(context),
      body: _buildBottomDrawerBody(context),
      headerHeight: _headerHeight,
      drawerHeight: _bodyHeight,
      color: Colors.transparent,
      controller: _controller,
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
        : Colors.blue;

    late Color backColor = Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 20, 20, 20)
        : backgroundColor;
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
              color: backgroundColor,
              child: Text(
                "See All Vehicles",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            )
          ],
        ),
        new Container(
          alignment: Alignment.topCenter,
          padding: new EdgeInsets.only(top: 3, right: 20.0, left: 20.0),
          child: new Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: new Stack(children: <Widget>[
                new Image(image: AssetImage("assets/arrow-bg.png")),
                new Positioned(
                    child: new Image(image: AssetImage("assets/arrow.png")),
                    left: 43,
                    top: 10)
              ])),
        )
      ],
    );
  }

  Widget _buildBottomDrawerBody(BuildContext context) {
    late Color fontColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    late Color backColor = Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 20, 20, 20)
        : backgroundColor;
    return Container(
      width: double.infinity,
      height: _bodyHeight,
      color: backColor,
      child: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 4,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(3, (index) {
          return Center(child: cardVehicle("car","assets/simpleCar.svg"));
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget cardVehicle(String vehicleName,String assetPath) {
  return (Container(
    alignment: Alignment.topCenter,
    padding: EdgeInsets.all(9.0),
    decoration: BoxDecoration(
        color: Colors.white70, borderRadius: BorderRadius.circular(8)),
    width: 65,
    height: 65,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(assetPath),
        Text(vehicleName)
      ],
    )
  ));
}

// Row(
// mainAxisAlignment: MainAxisAlignment.end,
// children: [
// cardVehicle(),
// SizedBox(
// width: 5,
// ),
// cardVehicle(),
// SizedBox(
// width: 5,
// ),
// cardVehicle(),
// SizedBox(
// width: 5,
// ),
// cardVehicle()
// ],
// ),
