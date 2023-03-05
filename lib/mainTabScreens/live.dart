import 'dart:async';
import 'dart:core';
import 'dart:ui';

import 'package:cargpstracker/allVehicle.dart';
import 'package:cargpstracker/main.dart';
import 'package:cargpstracker/mainTabScreens/updateVehicle.dart';
import 'package:cargpstracker/mainTabScreens/updateVehicle.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/models/point.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/spalshScreen.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/theme_preference.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class Live extends StatefulWidget {
  const Live({
    Key? key,
  }) : super(key: key);

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
  bool drawerOpen = true;
  late double zoom = 11.0;

  Point? currentPos = Point(
      lat: 0.0, lon: 0.0, dateTime: '', speed: 0.0, mileage: 0.0, heading: 0.0);
  Point defaultPos = Point(
      lat: 41.025819,
      lon: 29.230415,
      dateTime: "",
      speed: 0.0,
      mileage: 0,
      heading: 0.0);
  LatLng currentLatLng = LatLng(35.7159678, 51.2870684);
  late final MapController _mapController;
  var interActiveFlags = InteractiveFlag.all;
  static const double CHANGE_ZOOM = 12;
  bool theme = false;
  late ThemePreferences _preferences;
  late TextStyle textStyle = const TextStyle(
      fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'IranSans');
  late Color btnColor;
  Device? currentDevice;

  @override
  void dispose() {
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
    startTimer();
  }

  @override
  void deactivate() {
    print("deactivate");
    super.deactivate();
  }

  void startTimer() async {
    await getCurrentDevice();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      _getCurrentLocation();
    });
  }

  Future<void> getCurrentDevice() async {
    if (StoreProvider.of<AppState>(context).state.devices.isNotEmpty) {
      setState(() {
        currentDevice = StoreProvider.of<AppState>(context).state.devices[0];
      });
    }
    print('currentDevice = $currentDevice');
  }

  void _getCurrentLocation() async {
    try {
      Point? curPoint = await getCurrentLocation(currentDevice!);
      if (curPoint == null) return;
      setState(() {
        currentPos = curPoint;
        currentLatLng = LatLng(curPoint.lat, curPoint.lon);
      });
    } catch (e) {
      print('$e');
    }
  }

  void updatePoint() async {
    _getCurrentLocation();
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
    super.build(context);
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        key: _key,
        drawerEnableOpenDragGesture: true,
        body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            return currentDevice == null
                ? const Center(child: Text("there is no device to show"))
                : buildMap(themeNotifier);
          },
        ),
        extendBody: true,
        bottomNavigationBar: myAllVehicle(
          selectedDevice: _onSelectedDevice,
          selectedDeviceIndex: 0,
        ),
      );
    });
  }

  Row _floatingBottons() {
    btnColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.blue
        : lightIconColor;

    final List<Locale> systemLocales = window.locales;
    late double screenWidth = MediaQuery.of(context).size.width;
    late double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BlurBox(context, currentDevice!, currentPos!),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: null,
              // backgroundColor: btnColor,
              child: const Icon(Icons.location_searching, color: Colors.black),
              onPressed: () {
                updatePoint();
              },
            ),
            const SizedBox(height: 5),
            // Zoom In
            FloatingActionButton(
              heroTag: null,
              // backgroundColor: btnColor,
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
              heroTag: null,
              // backgroundColor: btnColor,
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
              heroTag: null,
              // backgroundColor: btnColor,
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

  Widget BlurBox(
      BuildContext context, Device currentDevice, Point currentPoint) {
    return Padding(
        padding: EdgeInsets.only(
            top: 50,
            left: Directionality.of(context) == TextDirection.ltr ? 20 : 0,
            right: Directionality.of(context) == TextDirection.rtl ? 20 : 0),
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
                        margin: EdgeInsets.all(2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: BorderSpacerColor,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 20),
                            Text("currentBlurBoxTitle".tr, style: textStyle),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateVehicle(
                                            currentDeveice: currentDevice)),
                                  );
                                },
                                icon: Icon(Icons.info, size: 15))
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, left: 5, right: 5),
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
                                      "Serial".tr + ' : ',
                                      style: textStyle,
                                    ),
                                    Text('${currentDevice.serial}',
                                        style: TextStyle(fontSize: 12))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "speed".tr + ' : ',
                                      style: textStyle,
                                    ),
                                    Text('${currentPoint.speed} km/h',
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
                                    Text('${currentPoint.mileage}',
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
                                    Text(currentPoint.dateTime,
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
                                        '${currentPoint.lat.toStringAsFixed(5)}',
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
                                        '${currentPoint.lon.toStringAsFixed(5)}',
                                        style: TextStyle(fontSize: 12))
                                  ],
                                ),
                              ],
                            ),
                            _vehicleIcon(context, currentDevice)
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ));
  }

  String getMapThem() {
    return Theme.of(context).brightness == Brightness.dark
        ? AppConstants.DARK_STYLE
        : AppConstants.LIGHT_STYLE;
  }

  Scaffold buildMap(ThemeModel themeNotifier) {
    StreamController<void> resetController = StreamController.broadcast();
    var markers = <Marker>[
      Marker(
          width: 80,
          height: 80,
          point: currentLatLng,
          builder: (ctx) => getMarkerPoint()),
    ];

    // if (currentDevice) {
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
            center: currentDevice == null
                ? LatLng(35.7159678, 51.2870684)
                : LatLng(currentLatLng.latitude, currentLatLng.longitude),
            interactiveFlags: interActiveFlags,
            enableMultiFingerGestureRace: true),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/saamezoji/${sattliteChecked ? AppConstants.SATELLITE_STYLE : getMapThem()}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
            additionalOptions: {
              'mapStyleId': AppConstants.mapBoxStyleId,
              'accessToken': AppConstants.mapBoxAccessToken,
            },
          ),
          if (currentDevice != null) MarkerLayerOptions(markers: markers)
        ],
      ),
      floatingActionButton: _floatingBottons(),
    );
    // }
    // else {
    //   return Scaffold(
    //     body: Center(
    //         child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [Center(child: Text('Please wait its loading...'))],
    //     )),
    //   );
    // }
  }

  Widget _vehicleIcon(BuildContext context, Device device) {
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
