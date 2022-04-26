import 'dart:core';

import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/maplive.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with AutomaticKeepAliveClientMixin<StartPage> {
  late String _name = 'befor';

  @override
  void initState() {
    super.initState();
    // print('initState Live');
    loadData();
  }

  void loadData() async {
    String dsd = await fetch();
    setState(() {
      _name = dsd;
    });
  }

  Future<String> fetch() async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://185.208.175.202:4680/live/'));
      request.fields.addAll({'serial': '027028356897'});
      // request.headers.addAll({'Access-Control-Allow-Origin': '*'});
      http.StreamedResponse response = await request.send();

      return response.statusCode.toString();
    } catch (error) {
      // print('Error add project $error');
      return "error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 200, bottom: 0, left: 10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(100, 50),
                primary: Colors.blue, // background
                onPrimary: Colors.white, // foreground
                padding: EdgeInsets.only(top: 5),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text('ورود'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(100, 50),
                primary: Colors.blue, // background
                onPrimary: Colors.white, // foreground
                padding: EdgeInsets.only(top: 5),
              ),
              onPressed: () {},
              child: Text('نسخه آزمایش'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              'Hello, $_name',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
