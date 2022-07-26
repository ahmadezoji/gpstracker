import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:developer';
import 'package:cargpstracker/bottomDrawer.dart';
import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/theme_preference.dart';
import 'package:http/http.dart' as http;
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:cargpstracker/main.dart';

import 'package:cargpstracker/models/point.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  late bool isSwitched = false;
  late Timer _timer;
  double _headerHeight = 60.0;
  double _bodyHeight = 180.0;
  BottomDrawerController _controller = BottomDrawerController();

  bool drawerOpen = true;
  late double speed = 0.0;
  late double heading = 0.0;
  late double mile = 0;
  late String date = '';

  late double zoom = 11.0;

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

  bool theme = false;
  late ThemePreferences _preferences;

  String light = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  String dark =
      'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png';
  String sattlite =
      'https://api.mapbox.com/v4/mapbox.satellite/{z}/{x}/{y}@2x.jpg90?access_token=${MyApp.ACCESS_TOKEN}';

  Device? currentDevice;

  @override
  void dispose() {
    // mapController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<bool> getTheme() async {
    return await _preferences.getTheme();
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    getCurrentDevice();
    // _determinePosition();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      currentPos = (await fetch())!;
      if (currentPos == null) return;
      setState(() {
        speed = currentPos.getSpeed();
        mile = currentPos.getMileage();
        heading = currentPos.getHeading();
        date = currentPos.getDateTime();
        currentLatLng = LatLng(currentPos.lat, currentPos.lon);
      });
      if (!bZoom) {
        _mapController.move(currentLatLng, 11);
        bZoom = true;
      }
    });
    // print('initState Live');
  }

  void getCurrentDevice() async {
    Map<String, dynamic> map = await loadJson('device');
    currentDevice = Device.fromJson(map);
  }

  Future<Point?> fetch() async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://130.185.77.83:4680/live/'));
      request.fields.addAll({'serial': currentDevice!.serial});
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
        bottomNavigationBar: MyBottomDrawer(
          speed: speed,
          heading: heading,
          mile: mile,
          date: date,
        ),
      ));
    });
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
            setState(() {
              zoom = zoom + 1;
            });
            _mapController.move(_mapController.center, zoom);
          },
        ),
        const SizedBox(height: 5),

        // Zoom Out
        FloatingActionButton(
          heroTag: "btn3",
          child: const Icon(Icons.zoom_out),
          onPressed: () {
            setState(() {
              zoom = zoom - 1;
            });
            _mapController.move(_mapController.center, zoom);
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

  String getMapThem() {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  Scaffold buildMap(ThemeModel themeNotifier) {
    StreamController<void> resetController = StreamController.broadcast();
    var markers = <Marker>[
      Marker(
        width: 80.0,
        height: 80.0,
        point: currentLatLng,
        builder: (ctx) => new Container(
            child: Icon(
          currentDevice!.type == 'Car' ? Icons.car_rental : Icons.two_wheeler,
          size: 25,
          color: Colors.blue,
        )),
      ),
    ];
    if (currentDevice != null) {
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
            TileLayerOptions(
              reset: resetController.stream,
              urlTemplate: sattliteChecked ? sattlite : getMapThem(),
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(markers: markers)
          ],
        ),
        floatingActionButton: _floatingBottons(),
      );
    } else {
      return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Center(child: Text('Please wait its loading...'))],
        )),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
