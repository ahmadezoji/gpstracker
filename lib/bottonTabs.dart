import 'package:cargpstracker/mainTabScreens/history.dart';
import 'package:cargpstracker/mainTabScreens/live.dart';
import 'package:cargpstracker/mainTabScreens/setting.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 1;

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
    late Color fontColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.blue;

    late Color backColor = Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 20, 20, 20)
        : Colors.white;
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image(image: AssetImage("assets/gpsplus.png")),
              label: 'Setting'.tr,
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
          unselectedItemColor: fontColor,
          unselectedLabelStyle: TextStyle(fontSize: 18, color: Colors.pink),
        ),
      );
    });
  }
}
