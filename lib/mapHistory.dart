import 'dart:convert';
import 'dart:io';

import 'package:cargpstracker/main.dart';
import 'package:cargpstracker/models/point.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:developer';

import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class mapHistory extends StatefulWidget {
  mapHistory({Key? key}) : super(key: key);

  @override
  _mapHistoryState createState() => _mapHistoryState();
}

class _mapHistoryState extends State<mapHistory> {
  //DateTime selectedDate = DateTime.now();
  String serial = '';
  String label = '';
  String selectedDate = Jalali.now().toJalaliDateTime();
  late LatLng pos = new LatLng(41.025819, 29.230415);
  late MapboxMapController mapController;
  var currentIndex = 1;

  List<Point> dirArr = [];

  late Jalali tempPickedDate;
  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.onCircleTapped.add(_onCircleTapped);
  }

  void _onCircleTapped(Circle circle) {
    Point p = dirArr.elementAt(int.parse(circle.id));
    _showSnackBar(p);
  }

  _showSnackBar(Point p) {
    String speed = p.speed.toString();
    final snackBar = SnackBar(
        content: Text('speed :  $speed km/h',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        backgroundColor: Theme.of(context).primaryColor);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onMapCliked(LatLng latlon) {}
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
      print('saam serial = ${serial} && stamp = ${stamp}');
      // log('serila history = $serial');
      // final snackBar = SnackBar(
      //     content: Text('serial $serial',
      //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
      //     backgroundColor: Theme.of(context).primaryColor);
      //
      // ScaffoldMessenger.of(context).clearSnackBars();
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);

      dirArr.clear();
 
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://185.208.175.202:4680/history/'));
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
  void initState() {
    super.initState();

    Timestamp myTimeStamp =
        Timestamp.fromDate(Jalali.now().toDateTime()); //To TimeStamp
    fetch(myTimeStamp.seconds.toString());
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blue,
              child: MapboxMap(
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
            ),
          ),
        ],
      ),
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

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 10))) &&
        day.isBefore(DateTime.now().add(Duration(days: 5))))) {
      return true;
    }
    return false;
  }
}

class $ {}
