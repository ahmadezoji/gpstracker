import 'package:cargpstracker/mainTabScreens/history.dart';
import 'package:cargpstracker/mainTabScreens/live.dart';
import 'package:cargpstracker/mainTabScreens/setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 2;

  final List<Widget> _widgetOptions = <Widget>[
    Setting(),
    Live(),
    History(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Art'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Live'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History'.tr,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        // fixedColor: Colors.red,
        selectedLabelStyle: TextStyle(color: Colors.red, fontSize: 20),
        unselectedFontSize: 16,
        selectedIconTheme:
            IconThemeData(color: Colors.blue, opacity: 1.0, size: 30.0),
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(fontSize: 18, color: Colors.pink),
      ),
    );
  }
}
