import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:cargpstracker/bottomDrawer.dart';
import 'package:cargpstracker/main.dart';
import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/point.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/theme_preference.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

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

  late double _screenWidth = MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    getCurrentDevice();
    startTimer();
  }

  void startTimer() {
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

  Future<void> getCurrentLocation() async {
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
  }

  void _onSelectedDevice(Device device) {
    setState(() {
      currentDevice = device;
    });
    getCurrentLocation();
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
          selectedDevice: _onSelectedDevice,
        ),
      ));
    });
  }

  Row _floatingBottons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
            padding: EdgeInsets.only(top: 50, left: 30),
            //blure box
            child: Container(
              height: 150, //_screenWidth * 0.45,
              width: 250, //_screenWidth * 0.45,

              child: ClipRRect(
                // make sure we apply clip it properly
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: BorderSpacerColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Text('YOUR CURRENT LOCATION',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 10, left: 5, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Speed : ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('$speed km/h',
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Interval : ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('1000 ms',
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'mile : ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('$mile',
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'date : ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('$date',
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'lat : ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('${currentPos.lat}',
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'lon : ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('${currentPos.lon}',
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                  ],
                                ),
                                _vehicleIcon(context, currentDevice!)
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              ),
            )),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: lightIconColor,
              heroTag: "btn2",
              child: const Icon(Icons.location_searching, color: Colors.black),
              onPressed: () {
                getCurrentLocation();
                _mapController.move(currentLatLng, 18);
              },
            ),
            const SizedBox(height: 5),
            // Zoom In
            FloatingActionButton(
              backgroundColor: lightIconColor,
              heroTag: "btn2",
              child: const Icon(Icons.zoom_in, color: Colors.black),
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
              backgroundColor: lightIconColor,
              heroTag: "btn3",
              child: const Icon(Icons.zoom_out, color: Colors.black),
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
              backgroundColor: lightIconColor,
              heroTag: "btn4",
              child: const Icon(Icons.satellite, color: Colors.black),
              onPressed: () {
                setState(() {
                  sattliteChecked = !sattliteChecked;
                });
              },
            ),
            const SizedBox(height: 100),
          ],
        )
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
        width: 80,
        height: 80,
        point: currentLatLng,
        builder: (ctx) => currentDevice?.type == "car"
            ? Icon(
                Icons.car_crash,
                color: Colors.blue,
              )
            : Icon(
                Icons.motorcycle,
                color: Colors.blue,
              ),
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
              enableMultiFingerGestureRace: true),
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

  Widget _vehicleIcon(BuildContext context, Device device) {
    String getTypeAsset(String type) {
      switch (type) {
        case "car":
          {
            return "assets/minicar.svg";
          }
          break;

        case "motor":
          {
            return "assets/minimotor.svg";
          }
          break;
        case "truck":
          {
            return "assets/minitruck.svg";
          }
          break;
        default:
          {
            return "assets/minicar.svg";
          }
          break;
      }
    }
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.blue, width: 1),
          color: Colors.white),
      child: SvgPicture.asset(
        getTypeAsset(device.type),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
