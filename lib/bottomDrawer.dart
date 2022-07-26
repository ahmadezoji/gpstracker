import 'dart:core';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';

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
  double _headerHeight = 60.0;
  double _bodyHeight = 180.0;
  BottomDrawerController _controller = BottomDrawerController();
  bool drawerOpen = true;
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
      color: Colors.white,
      controller: _controller,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 60,
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
        : Colors.white;
    return Container(
      height: _headerHeight,
      color: backColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              top: 10.0,
            ),
            child: TextButton(
              child: Text(
                'Speed :  ${widget.speed.toString()} km/h',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: fontColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              onPressed: () {
                if (drawerOpen)
                  _controller.close();
                else
                  _controller.open();
              },
            ),
          ),
          Spacer(),
          Divider(
            height: 1.0,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomDrawerBody(BuildContext context) {
    late Color fontColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    late Color backColor = Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 20, 20, 20)
        : Colors.white;
    return Container(
      width: double.infinity,
      height: _bodyHeight,
      color: backColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'mile :  ${widget.mile.toString()} mile',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: fontColor, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              'heading : ${widget.heading.toString()} ',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: fontColor, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              'date : ${widget.date.toString()} ',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: fontColor, fontWeight: FontWeight.bold, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}



// Widget myBottomDrawer(
//     BuildContext context, double speed, double mile, double heading) {
//   return BottomDrawer(
//     header: _buildBottomDrawerHead(context),
//     body: _buildBottomDrawerBody(context),
//     headerHeight: _headerHeight,
//     drawerHeight: _bodyHeight,
//     color: Colors.white,
//     controller: _controller,
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.15),
//         blurRadius: 60,
//         spreadRadius: 5,
//         offset: const Offset(2, -6), // changes position of shadow
//       ),
//     ],
//   );
// }
