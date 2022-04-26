import 'dart:convert';
import 'dart:io';

import 'package:cargpstracker/main.dart';
import 'package:cargpstracker/mainTabScreens/pincode.dart';
import 'package:cargpstracker/models/point.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:developer';

class mapLive extends StatefulWidget {
  mapLive({Key? key}) : super(key: key);

  @override
  _mapLiveState createState() => _mapLiveState();
}

class _mapLiveState extends State<mapLive> {
  // late LatLng pos = new LatLng(41.025819, 29.230415);
  //name: 'start',
  String serial = '';
  Point pos = const Point(
      lat: 41.025819,
      lon: 29.230415,
      dateTime: "",
      speed: 0.0,
      mileage: 0,
      heading: 0.0);
  late MapboxMapController mapController;
  late double speed = 0.0;
  late double heading = 0.0;

  late bool isSwitched = false;

  bool bZoom = false;

  Point lastPos = new Point(
      lat: 0.0, lon: 0.0, dateTime: '', speed: 0.0, mileage: 0.0, heading: 0.0);
  Point currentPos = new Point(
      lat: 0.0, lon: 0.0, dateTime: '', speed: 0.0, mileage: 0.0, heading: 0.0);

  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  late double mile = 0;
  final sattlite = 'mapbox://styles/mapbox/satellite-v9';
  final street = 'mapbox://styles/mapbox/streets-v11';
  final dart = 'mapbox://styles/mapbox/dark-v10';
  final light = 'mapbox://styles/mapbox/light-v10';

  String selectedStyle = 'mapbox://styles/mapbox/light-v10';

  // ignore: unused_field
  late Timer _timer;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  void _onMapCliked(LatLng latlon) {}

  Future<Point?> fetch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      serial = prefs.getString('serial')!;

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://185.208.175.202:4680/live/'));
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
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      currentPos = (await fetch())!;
      if (currentPos == null) return;
      // if (speed + 5.0 >= position!.getSpeed()) {
      //   CameraPosition newcam = CameraPosition(
      //       target: LatLng(pos.getLat(), pos.getLon()), zoom: 15);
      // }
      setState(() {
        speed = currentPos.getSpeed();
        mile = currentPos.getMileage();
        heading = currentPos.getHeading();
      });
      // addSymbol(currentPos);
      updateCircle(currentPos);
    });
    // _addCircle();

    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      endDrawer: Drawer(
          backgroundColor: Colors.white,
          child: Center(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Devices'),
                ),
                ListTile(
                  title: const Text('ماشین دوم'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('ماشین سوم'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )),
      body: Column(
        children: [
          Expanded(child: buildMap(), flex: 8),
          Expanded(
            child: StatusBar(),
            flex: 2,
          )
        ],
      ),
      floatingActionButton: _floatingBottons(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Column(
  //       children: [
  //         Expanded(child: buildMap(), flex: 8),
  //         Expanded(
  //           child: StatusBar(),
  //           flex: 2,
  //         )
  //       ],
  //     ),
  //     floatingActionButton: _floatingBottons(),
  //   );
  // }

  Column _floatingBottons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(height: 5),
        // Zoom In
        Switch(
          value: isSwitched,
          onChanged: (value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PinCodePage(), fullscreenDialog: true));
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
            Scaffold.of(context).openDrawer();
            // _key.currentState!.openDrawer();
          },
        ),
        const SizedBox(height: 100),
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
      ],
    );
  }

  MapboxMap buildMap() {
    return MapboxMap(
        styleString: selectedStyle,
        accessToken: MyApp.ACCESS_TOKEN,
        onMapCreated: _onMapCreated,
        onMapClick: (point, latlng) {
          // String msg =
          //     'lat = ${latlng.latitude} & lon = ${latlng.longitude}';
          // print(msg);
          // Fluttertoast.showToast(msg: msg);
        },
        onStyleLoadedCallback: () => updateCircle(pos),
        initialCameraPosition: CameraPosition(
            target: LatLng(pos.getLat(), pos.getLon()), zoom: 15));
  }

  Container StatusBar() {
    return Container(
      alignment: Alignment.bottomCenter,
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Speed :  ${speed.toString()} km/h',
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
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
    mapController.clearCircles();
    mapController.addCircle(CircleOptions(
        circleColor: 'blue',
        geometry: LatLng(pos.getLat(), pos.getLon()),
        circleRadius: 8));
  }
}

class $ {}

//////for tooltip
//  Expanded(
//             flex: 1,
//             child: Container(
//               alignment: Alignment.topLeft,
//               color: Color.fromARGB(255, 204, 197, 174),
//               child: Column(
//                 children: [
//                   Text(
//                     'Speed, ${speed.toString()} km/h',
//                     textAlign: TextAlign.left,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                   Text(
//                     'mile, ${mile.toString()} mile',
//                     textAlign: TextAlign.left,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                   Text(
//                     'heading, ${heading.toString()} ',
//                     textAlign: TextAlign.left,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 20),
//                   )
//                 ],
//               ),
//             )
//             )
