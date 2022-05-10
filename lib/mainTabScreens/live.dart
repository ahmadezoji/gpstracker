import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:cargpstracker/main.dart';

import 'package:cargpstracker/models/point.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Live extends StatefulWidget {
  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> with AutomaticKeepAliveClientMixin<Live> {
  String serial = '';
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  bool bZoom = false;

  final sattlite = 'mapbox://styles/mapbox/satellite-v9';
  final street = 'mapbox://styles/mapbox/streets-v11';
  final dart = 'mapbox://styles/mapbox/dark-v10';
  final light = 'mapbox://styles/mapbox/light-v10';
  String selectedStyle = 'mapbox://styles/mapbox/light-v10';

  late bool isSwitched = false;
  late Timer _timer;
  double _headerHeight = 60.0;
  double _bodyHeight = 180.0;
  BottomDrawerController _controller = BottomDrawerController();

  bool drawerOpen = true;
  late double speed = 0.0;
  late double heading = 0.0;
  late double mile = 0;

  Point currentPos = new Point(
      lat: 0.0, lon: 0.0, dateTime: '', speed: 0.0, mileage: 0.0, heading: 0.0);
  Point defaultPos = Point(
      lat: 41.025819,
      lon: 29.230415,
      dateTime: "",
      speed: 0.0,
      mileage: 0,
      heading: 0.0);
  late MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    mapController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      currentPos = (await fetch())!;
      if (currentPos == null) return;
      setState(() {
        speed = currentPos.getSpeed();
        mile = currentPos.getMileage();
        heading = currentPos.getHeading();
      });
      // addSymbol(currentPos);
      updateCircle(currentPos);
    });
    // print('initState Live');
  }

  Future<Point?> fetch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      serial = prefs.getString('serial')!;

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://130.185.77.83:4680/live/'));
      request.fields.addAll({'serial': serial});
      request.headers.addAll({'Access-Control-Allow-Origin': '*'});
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final json = jsonDecode(responseString);

        return Point.fromJson(json["features"][0]);
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      // print('Error add project $error');
      return null;
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

  void addSymbol(Point newPos) {
    mapController.clearSymbols();
    // CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(
    //     LatLng(newPos.getLat(), newPos.getLon()), 11);

    // mapController.moveCamera(cameraUpdate);
    mapController.addSymbol(SymbolOptions(
        geometry: LatLng(newPos.getLat(),
            newPos.getLon()), // location is 0.0 on purpose for this example
        iconImage: 'airport-15',
        iconSize: 2,
        iconRotate: newPos.getHeading()));
  }

  void updateCircle(Point pos) async {
    if (!bZoom) {
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(
          LatLng(
            currentPos.getLat(),
            currentPos.getLon(),
          ),
          11);
      mapController.moveCamera(cameraUpdate);
    }
    bZoom = true;
    mapController.clearCircles();
    mapController.addCircle(CircleOptions(
        circleColor: 'blue',
        geometry: LatLng(pos.getLat(), pos.getLon()),
        circleRadius: 8));
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

        // Zoom In
        Switch(
          value: isSwitched,
          onChanged: (value) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) =>   AlertDialog(
                title: const Text('AlertDialog Title'),
                content: const Text('this is a demo alert diolog'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Approve'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            );
            setState(() {
              isSwitched = value;
              print(isSwitched);
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
        const SizedBox(height: 5),
        // Zoom In
        FloatingActionButton(
          child: const Icon(Icons.add_link),
          backgroundColor: Colors.red,
          onPressed: () {
            // Scaffold.of(context).openDrawer();
            /// open the bottom drawer.
            // _controller.open();
            // _key.currentState!.openDrawer();
            Scaffold.of(context).openDrawer();
          },
        ),
        const SizedBox(height: 120),
        // Zoom In
        FloatingActionButton(
          child: const Icon(Icons.location_searching),
          onPressed: () {
            CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(
                LatLng(
                  currentPos.getLat(),
                  currentPos.getLon(),
                ),
                11);
            mapController.moveCamera(cameraUpdate);
          },
        ),
        const SizedBox(height: 5),
        // Zoom In
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

  Scaffold buildMap() {
    return Scaffold(
      body: MapboxMap(
          styleString: selectedStyle,
          accessToken: MyApp.ACCESS_TOKEN,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
              target: LatLng(defaultPos.getLat(), defaultPos.getLon()),
              zoom: 15)),
      floatingActionButton: _floatingBottons(),
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // Position pos = await Geolocator.getCurrentPosition();
    // defaultPos.setLat(pos.latitude);
    // defaultPos.setLon(pos.longitude);

    return await Geolocator.getCurrentPosition();
  }

  @override
  bool get wantKeepAlive => true;
}

// showDialog<String>(
// context: context,
// builder: (BuildContext context) =>   AlertDialog(
// title: const Text('AlertDialog Title'),
// content: const Text('this is a demo alert diolog'),
// actions: <Widget>[
// TextButton(
// child:  Text(pos.latitude.toString()),
// onPressed: () {
// Navigator.of(context).pop();
// },
// ),
// TextButton(
// child:  Text(pos.longitude.toString()),
// onPressed: () {
// Navigator.of(context).pop();
// },
// ),
// ],
// )
// );
