import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
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
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

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

  Point? currentPos = new Point(
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
  static const double CHANGE_ZOOM = 12;

  bool theme = false;
  late ThemePreferences _preferences;

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
    startTimer();
  }

  void startTimer() async {
    await getCurrentDevice();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      getCurrentLocation();
    });
    // _mapController.move(currentLatLng, CHANGE_ZOOM);
  }

  Future<void> getCurrentDevice() async {
    Map<String, dynamic> map = await loadJson('device');
    print('map $map');
    currentDevice = Device.fromJson(map);
  }

  Future<void> getCurrentLocation() async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://130.185.77.83:4680/live/'));
      request.fields.addAll({'serial': currentDevice!.serial});
      // request.headers.addAll({'Access-Control-Allow-Origin': '*'});
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final json = jsonDecode(responseString);
        // return Point.fromJson(json["features"][0]);
        var curPoint = Point.fromJson(json["features"][0]);
        setState(() {
          currentPos = curPoint;
          speed = curPoint.getSpeed();
          mile = curPoint.getMileage();
          heading = curPoint.getHeading();
          date = curPoint.getDateTime();
          currentLatLng = LatLng(curPoint.lat, curPoint.lon);
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      // print('Error add project $error');
      return null;
      // return new Point(
      //     lat: 0.0, lon: 0.0, dateTime: '', speed: 0.0, mileage: 0.0, heading: 0.0);
    }
    return null;
    // return new Point(
    //     lat: 0.0, lon: 0.0, dateTime: '', speed: 0.0, mileage: 0.0, heading: 0.0);
  }

  void updatePoint() async {
    await getCurrentLocation();
    _mapController.move(currentLatLng, CHANGE_ZOOM);
  }

  Future<void> _onSelectedDevice(Device device) async {
    setState(() {
      currentDevice = device;
    });
    updatePoint();
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
    const textStyle = TextStyle(
        fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'IranSans');
    Color btnColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.blue
        : lightIconColor;

    // Locale myLocale = Localizations.localeOf(context);
    // print(Localizations.localeOf(context).toString());
    final List<Locale> systemLocales = window.locales;
    // DateTime dt = DateTime.parse(date);
    // print(dt.toLocal());

    late double screenWidth = MediaQuery.of(context).size.width;
    late double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
            padding: EdgeInsets.only(
                top: 50,
                left: Directionality.of(context) == TextDirection.ltr ? 20 : 0,
                right:
                    Directionality.of(context) == TextDirection.rtl ? 20 : 0),
            // padding: EdgeInsets.all(0.1*screenWidth),

            //blure box
            child: Container(
              height: 180, //_screenWidth * 0.45,
              width: 270, //_screenWidth * 0.45,

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
                            child: Text("currentBlurBoxTitle".tr,
                                style: textStyle),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 10, left: 5, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "speed".tr + ' : ',
                                          style: textStyle,
                                        ),
                                        Text('$speed km/h',
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "interval".tr + ' : ',
                                          style: textStyle,
                                        ),
                                        Text('1000 ms',
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "mile".tr + ': ',
                                          style: textStyle,
                                        ),
                                        Text('$mile',
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "date".tr + ': ',
                                          style: textStyle,
                                        ),
                                        //dt.toJalali().toString()
                                        Text(date,
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "lat".tr + ': ',
                                          style: textStyle,
                                        ),
                                        Text(
                                            '${currentPos!.lat.toStringAsFixed(5)}',
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "lon".tr + ': ',
                                          style: textStyle,
                                        ),
                                        Text(
                                            '${currentPos!.lon.toStringAsFixed(5)}',
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
              backgroundColor: btnColor,
              heroTag: "btn2",
              child: const Icon(Icons.location_searching, color: Colors.black),
              onPressed: () {
                updatePoint();
              },
            ),
            const SizedBox(height: 5),
            // Zoom In
            FloatingActionButton(
              backgroundColor: btnColor,
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
              backgroundColor: btnColor,
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
              backgroundColor: btnColor,
              heroTag: "btn4",
              child: const Icon(Icons.layers, color: Colors.black),
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
    return Theme.of(context).brightness == Brightness.dark ? AppConstants.DARK_STYLE : AppConstants.LIGHT_STYLE;
  }

  Scaffold buildMap(ThemeModel themeNotifier) {
    StreamController<void> resetController = StreamController.broadcast();
    var markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: currentLatLng,
        builder: (ctx) => Icon(
          Icons.my_location,
          color: Colors.blue,
        ),
      ),
    ];

    if (currentDevice != null) {
      return Scaffold(
        drawerEnableOpenDragGesture: true,
        body: FlutterMap(
          children: [
            Center(
                child: Container(
              width: 150,
              height: 150,
              color: Colors.yellow,
            ))
          ],
          mapController: _mapController,
          options: MapOptions(
              center: LatLng(currentLatLng.latitude, currentLatLng.longitude),
              interactiveFlags: interActiveFlags,
              enableMultiFingerGestureRace: true),
          layers: [
            // TileLayerOptions(
            //   reset: resetController.stream,
            //   urlTemplate: sattliteChecked ? sattlite : getMapThem(),
            //   subdomains: ['a', 'b', 'c'],
            // ),
            TileLayerOptions(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/saamezoji/${sattliteChecked ? AppConstants.SATELLITE_STYLE : getMapThem()}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
              additionalOptions: {
                'mapStyleId': AppConstants.mapBoxStyleId,
                'accessToken': AppConstants.mapBoxAccessToken,
              },
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
