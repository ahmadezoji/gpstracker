import 'dart:core';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:cargpstracker/main.dart';

import 'package:cargpstracker/models/point.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History>
    with AutomaticKeepAliveClientMixin<History> {

  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  String serial = '';
  String label = '';
  String selectedDate = Jalali.now().toJalaliDateTime();
  late LatLng pos = new LatLng(41.025819, 29.230415);
  late MapboxMapController mapController;

  double _headerHeight = 60.0;
  double _bodyHeight = 180.0;
  BottomDrawerController _controller = BottomDrawerController();

  var currentIndex = 1;

  late double speed = 0.0;
  late double heading = 0.0;
  late double mile = 0;

  final sattlite = 'mapbox://styles/mapbox/satellite-v9';
  final street = 'mapbox://styles/mapbox/streets-v11';
  final dart = 'mapbox://styles/mapbox/dark-v10';
  final light = 'mapbox://styles/mapbox/light-v10';

  String selectedStyle = 'mapbox://styles/mapbox/light-v10';
  List<Point> dirArr = [];

  late Jalali tempPickedDate;

  @override
  void initState() {
    super.initState();
  }
  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.onCircleTapped.add(_onCircleTapped);
  }

  void _onCircleTapped(Circle circle) {
    log('circle = ${int.parse(circle.id)}');
    Point p = dirArr.elementAt(int.parse(circle.id));
    setState(() {
      speed = p.getSpeed();
      mile = p.getMileage();
      heading = p.getHeading();
    });
  }

  void _add() {
    mapController.clearLines();
    mapController.clearCircles();
    List<LatLng> points = [];
    for (Point point in dirArr) {
      points.add(LatLng(point.getLat(), point.getLon()));
    }
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(
        LatLng(
          points[0].latitude,
          points[0].longitude,
        ),
        11);
    mapController.moveCamera(cameraUpdate);

    mapController.addCircle(CircleOptions(
        circleColor: 'red',
        geometry: LatLng(points[0].latitude, points[0].longitude),
        circleRadius: 8));

    mapController.addLine(
      LineOptions(
        geometry: points,
        lineColor: "blue",
        lineWidth: 2.0,
        lineOpacity: 1.0,
      ),
    );

    // for (var i = 1; i < points.length - 1; i++) {
    //   mapController.addCircle(CircleOptions(
    //       circleColor: 'blue',
    //       geometry: LatLng(points[i].latitude, points[i].longitude),
    //       circleRadius: 8));
    // }

    mapController.addCircle(CircleOptions(
        circleColor: 'yellow',
        geometry: LatLng(points[points.length - 1].latitude,
            points[points.length - 1].longitude),
        circleRadius: 8));
  }

  void fetch(String stamp) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      serial = prefs.getString('serial')!;
      dirArr.clear();

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://130.185.77.83:4680/history/'));
      request.fields.addAll({'serial': serial, 'timestamp': stamp});
      // Map<String,String> headers= { "Accept": "application/json",
      //     "Access-Control_Allow_Origin": "*"};
      // request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {

        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final json = jsonDecode(responseString);
        for (var age in json["features"]) {
          Point p = Point.fromJson(age);
          dirArr.add(p);
        }
        _add();
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error add project $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawerEnableOpenDragGesture: false,
      body:buildMap(),
      extendBody: true,
      bottomNavigationBar:  _buildBottomDrawer(context),
    );
  }
  Scaffold buildMap() {
    return Scaffold(
      endDrawer: Drawer(
          backgroundColor: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  //"${selectedDate.toJalaliDateTime()}".split(' ')[0],
                  "${selectedDate}".split(' ')[0],
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    'Select date',
                    style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )),
      body: MapboxMap(
          styleString: selectedStyle,
          accessToken: MyApp.ACCESS_TOKEN,
          onUserLocationUpdated: (userLocation) {
            print("User location updated: ${userLocation.position}");
          },
          onMapCreated: _onMapCreated,
          onMapClick: (point, latlng) {},
          onStyleLoadedCallback: () => fetch(
              (Timestamp.fromDate(Jalali.now().toDateTime()))
                  .seconds
                  .toString()),
          initialCameraPosition: CameraPosition(target: pos, zoom: 13)),
      floatingActionButton: _floatingBottons(),
    );
  }
  Widget _buildBottomDrawer(BuildContext context) {
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
    return Container(
      height: _headerHeight,
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
                'Speed :  ${speed.toString()} km/h',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              onPressed: () {
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
    return Container(
      width: double.infinity,
      height: _bodyHeight,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'mile :  ${mile.toString()} mile',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              'heading : ${heading.toString()} ',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }

  Column _floatingBottons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          child: const Icon(Icons.zoom_in),
          onPressed: () {
            mapController.animateCamera(
              CameraUpdate.zoomIn(),
              // CameraUpdate.tiltTo(40),
            );
          },
        ),
        const SizedBox(height: 5),

        // Zoom Out
        FloatingActionButton(
          child: const Icon(Icons.zoom_out),
          onPressed: () {
            mapController.animateCamera(
              CameraUpdate.zoomOut(),
            );
          },
        ),
        const SizedBox(height: 5),

        // Change Style
        FloatingActionButton(
          child: const Icon(Icons.satellite),
          onPressed: () {
            selectedStyle = selectedStyle == light ? sattlite : light;
            setState(() {});
          },
        ),
        const SizedBox(height: 100),

      ],
    );
  }
  //change Flat to text button
  _selectDate(BuildContext context) async {
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1385, 8),
      lastDate: Jalali(1450, 9),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked.toJalaliDateTime();
      });

      Timestamp myTimeStamp =
      Timestamp.fromDate(picked.toDateTime()); //To TimeStamp
      print(myTimeStamp.seconds.toString());
      fetch(myTimeStamp.seconds.toString());
    }
  }


  @override
  bool get wantKeepAlive => true;
}
