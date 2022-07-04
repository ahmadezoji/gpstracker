import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:cargpstracker/theme_model.dart';
import 'package:http/http.dart' as http;
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:cargpstracker/main.dart';

import 'package:cargpstracker/models/point.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

// import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Live extends StatefulWidget {
  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> with AutomaticKeepAliveClientMixin<Live> {
  String serial = '';
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  bool bZoom = false;
  bool sattliteChecked = false;
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
  late LatLng currentLatLng = new LatLng(41.025819, 29.230415);
  late final MapController _mapController;
  var interActiveFlags = InteractiveFlag.all;

  @override
  void dispose() {
    // mapController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    // _determinePosition();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      currentPos = (await fetch())!;
      if (currentPos == null) return;
      setState(() {
        speed = currentPos.getSpeed();
        mile = currentPos.getMileage();
        heading = currentPos.getHeading();
        currentLatLng = LatLng(currentPos.lat, currentPos.lon);
      });
      if (!bZoom) {
        _mapController.move(currentLatLng, 11);
        bZoom = true;
      }
    });
    // print('initState Live');
  }

  Future<Point?> fetch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      serial = prefs.getString('serial')!;

      var request = http.MultipartRequest(
          'POST', Uri.parse('https://130.185.77.83:4680/live/'));
      request.fields.addAll({'serial': serial});
      // request.headers.addAll({'Access-Control-Allow-Origin': '*'});
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
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return GestureDetector(
          child: Scaffold(
        key: _key,
        drawerEnableOpenDragGesture: true,
        body: buildMap(themeNotifier),
        extendBody: true,
        bottomNavigationBar: _buildBottomDrawer(context),
      ));
    });
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
        const SizedBox(height: 5),
        // Zoom In
        FloatingActionButton(
          heroTag: "btn0",
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
          heroTag: "btn2",
          child: const Icon(Icons.location_searching),
          onPressed: () {
            _mapController.move(currentLatLng, 18);
          },
        ),
        const SizedBox(height: 5),
        // Zoom In
        FloatingActionButton(
          heroTag: "btn2",
          child: const Icon(Icons.zoom_in),
          onPressed: () {
            // mapController.animateCamera(
            //   CameraUpdate.zoomIn(),
            //   CameraUpdate.tiltTo(40),
            // );
          },
        ),
        const SizedBox(height: 5),

        // Zoom Out
        FloatingActionButton(
          heroTag: "btn3",
          child: const Icon(Icons.zoom_out),
          onPressed: () {
            // mapController.animateCamera(
            //   CameraUpdate.zoomOut(),
            // );
          },
        ),
        const SizedBox(height: 5),

        // Change Style
        FloatingActionButton(
          heroTag: "btn4",
          child: const Icon(Icons.satellite),
          onPressed: () {
            setState(() {
              sattliteChecked = !sattliteChecked;
            });
          },
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Scaffold buildMap(ThemeModel themeNotifier) {
    var markers = <Marker>[
      Marker(
        width: 80.0,
        height: 80.0,
        point: currentLatLng,
        builder: (ctx) => new Container(
            child: Icon(
          Icons.circle,
          size: 18,
          color: Colors.blue,
        )),
      ),
    ];
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(currentLatLng.latitude, currentLatLng.longitude),
          zoom: 5.0,
          interactiveFlags: interActiveFlags,
        ),
        layers: [
          // if(!sattliteChecked)
          !sattliteChecked
              ? TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                )
              : TileLayerOptions(
                  urlTemplate:
                      'https://api.mapbox.com/v4/mapbox.satellite/{z}/{x}/{y}@2x.jpg90?access_token={accessToken}',
                  additionalOptions: {'accessToken': MyApp.ACCESS_TOKEN},
                ),
          MarkerLayerOptions(markers: markers)
        ],
      ),
      floatingActionButton: _floatingBottons(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
