import 'package:cargpstracker/check_pattern.dart';
import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/mainTabScreens/setting.dart';
import 'package:cargpstracker/bottonTabs.dart';
import 'package:cargpstracker/setPattern.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const appTitle = 'GPS Tracker';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final bool switchVal = false;
  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', '').then((bool success) {
      print(success);
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void switchChange(BuildContext context, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedStrList = prefs.getStringList('pattern');
    List<int>? intProductList = savedStrList?.map((i) => int.parse(i)).toList();
    if (intProductList == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SetPattern(), fullscreenDialog: false));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  CheckPattern(pattern: intProductList, bswitch: value),
              fullscreenDialog: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: [
        Switch(
          value: false,
          onChanged: (value) {
            switchChange(context, value);
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
      ]),
      body: const Center(
        child: MyStatefulWidget(),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text("Logout".tr),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
