import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:cargpstracker/bottomDrawer.dart';
import 'package:cargpstracker/main.dart';
import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/point.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';

// import 'package:flutter_linear_datepicker/flutter_datepicker.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

// import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:provider/provider.dart';

class HistoryDemo extends StatefulWidget {
  @override
  _HistoryDemoState createState() => _HistoryDemoState();
}

class _HistoryDemoState extends State<HistoryDemo>
    with AutomaticKeepAliveClientMixin<HistoryDemo> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  String serial = '';
  String label = '';
  String selectedDate = ''; //Jalali.now().toJalaliDateTime();
  late Timestamp currentTimeStamp;
  late LatLng pos = new LatLng(41.025819, 29.230415);

  // late MapboxMapController mapController;
  bool sattliteChecked = false;
  double _headerHeight = 60.0;
  double _bodyHeight = 180.0;
  BottomDrawerController _controller = BottomDrawerController();

  var currentIndex = 1;

  late double speed = 0.0;
  late double heading = 0.0;
  late double mile = 0;
  late String date = '';

  List<Point> dirArr = [];
  List<LatLng> dirLatLons = [];
  List<CircleMarker> circleMarkers = [];
  // List<LatLng> markers;
  late Jalali tempPickedDate;
  late double zoomLevel = 5.0;
  late bool showPoint = false;
  late final MapController _mapController;
  var interActiveFlags = InteractiveFlag.all;
  late LatLng currentLatLng = new LatLng(35.7159678, 51.2870684);

  late double zoom = 11.0;

  Device? currentDevice;

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
    // Timestamp myTimeStamp =
    // Timestamp.fromDate('1663102800'); //To TimeStamp
    // currentTimeStamp = myTimeStamp;
    // print(myTimeStamp.seconds.toString());
    // fetch(myTimeStamp.seconds.toString());
    // fetch('1663102800');
    print('1663102800');
    fetch('1663102800');
    print('init HistoryDemo');
  }

  Future<Uint8List> loadMarkerImage() async {
    var byteData = await rootBundle.load("assets/finish.png");
    return byteData.buffer.asUint8List();
  }

  void fetch(String stamp) async {
    try {
      // final prefs = await SharedPreferences.getInstance();
      // serial = prefs.getString('serial')!;
      dirArr.clear();
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://130.185.77.83:4680/history/'));
      request.fields.addAll({'serial': '027028362416', 'timestamp': stamp});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final json = jsonDecode(responseString);
        dirLatLons.clear();
        circleMarkers.clear();
        dirArr.clear();
        for (var age in json["features"]) {
          Point p = Point.fromJson(age);
          dirLatLons.add(LatLng(p.lat, p.lon));
          circleMarkers.add(CircleMarker(
              point: LatLng(p.lat, p.lon), radius: 2, color: Colors.blue));
          dirArr.add(p);
        }
        setState(() {
          speed = dirArr[0].speed;
          mile = dirArr[0].mileage;
          heading = dirArr[0].heading;
          date = dirArr[0].dateTime;
        });
        _mapController.move(dirLatLons[0], 11);
        // _add();
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error add project $error');
    }
  }

  void _onSelectedDevice(Device device) {
    currentDevice = device;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        key: _key,
        drawerEnableOpenDragGesture: false,
        body: buildMap(),
        extendBody: true,
        bottomNavigationBar: MyBottomDrawer(selectedDevice: _onSelectedDevice,userLogined: false,userDevices: []),
      );
    });
  }

  String getMapThem() {
    return Theme.of(context).brightness == Brightness.dark
        ? AppConstants.DARK_STYLE
        : AppConstants.LIGHT_STYLE;
  }

  Scaffold buildMap() {
    StreamController<void> resetController = StreamController.broadcast();
    var markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: currentLatLng,
        builder: (ctx) => new Container(
            child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: backgroundColor,
          ),
          child: Text(
            'saam ezoji',
            style: TextStyle(color: Colors.blue, fontSize: 27),
          ),
        )),
      ),
    ];

    return Scaffold(
      endDrawer: Drawer(
          backgroundColor: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  //"${selectedDate.toJalaliDateTime()}".split(' ')[0],
                  "$selectedDate".split(' ')[0],
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    'Select date',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(currentLatLng.latitude, currentLatLng.longitude),
          zoom: zoomLevel,
          interactiveFlags: interActiveFlags,
        ),
        layers: [
          // MarkerLayerOptions(markers: markers),

          TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/saamezoji/${sattliteChecked ? AppConstants.SATELLITE_STYLE : getMapThem()}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
            additionalOptions: {
              'mapStyleId': AppConstants.mapBoxStyleId,
              'accessToken': AppConstants.mapBoxAccessToken,
            },
          ),
          if (showPoint)
            CircleLayerOptions(
              circles: circleMarkers,
            ),
          if (!showPoint)
            PolylineLayerOptions(
              polylines: [
                Polyline(
                    points: dirLatLons,
                    strokeWidth: 4.0,
                    color: Colors.purple,
                    isDotted: showPoint),
              ],
            ),
          // new MarkerLayerOptions(markers: markers),
        ],
      ),
      floatingActionButton: _floatingBottons(),
    );
  }

  void zoomout() {
    setState(() {
      zoomLevel = zoomLevel + 1;
    });
  }

  void onChangedPointShow(bool? value) {
    setState(() {
      showPoint = value!;
    });
  }

  Column _floatingBottons() {
    Color btnColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.blue
        : lightIconColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Checkbox(value: showPoint, onChanged: onChangedPointShow),
        FloatingActionButton(
          backgroundColor: btnColor,
          heroTag: "btn1",
          child: const Icon(Icons.date_range, color: Colors.black),
          onPressed: () {
            _selectDate(context);
          },
        ),
        const SizedBox(height: 50),
        FloatingActionButton(
          backgroundColor: btnColor,
          heroTag: "btn1",
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
          heroTag: "btn2",
          child: const Icon(Icons.zoom_out, color: Colors.black),
          onPressed: () {
            zoomout();
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
          heroTag: "btn3",
          child: const Icon(Icons.satellite, color: Colors.black),
          onPressed: () {
            // selectedStyle = selectedStyle == light ? sattlite : light;
            // fetch(currentTimeStamp.seconds.toString());
            setState(() {
              sattliteChecked = !sattliteChecked;
            });
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
      // print('selectedDate $selectedDate');

      Timestamp myTimeStamp =
          Timestamp.fromDate(picked.toDateTime()); //To TimeStamp
      currentTimeStamp = myTimeStamp;
      print(myTimeStamp.seconds.toString());
      fetch(myTimeStamp.seconds.toString());
    }
  }

  @override
  bool get wantKeepAlive => true;
}