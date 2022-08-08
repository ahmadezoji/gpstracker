import 'package:cargpstracker/mainTabScreens/GpsPlus.dart';
import 'package:cargpstracker/mainTabScreens/history.dart';
import 'package:cargpstracker/mainTabScreens/live.dart';
import 'package:cargpstracker/mainTabScreens/setting.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    GpsPlus(),
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
    late Color selectedFontColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    late Color unselectedFontColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    late Color backColor = Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 20, 20, 20)
        : backgroundColor;
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: backgroundColor,
          items: <BottomNavigationBarItem>[
            // BottomNavigationBarItem(
            //   icon: Image(image: AssetImage("assets/gpsplus.png")),
            //   label: 'Plus'.tr,
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Plus'.tr,
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
          selectedItemColor: selectedFontColor,
          onTap: _onItemTapped,
          // fixedColor: Colors.red,
          selectedLabelStyle: TextStyle(color: Colors.red, fontSize: 20),
          unselectedFontSize: 16,
          selectedIconTheme:
              IconThemeData(color: Colors.blue, opacity: 1.0, size: 30.0),
          unselectedItemColor: unselectedFontColor,
          unselectedLabelStyle: TextStyle(fontSize: 18, color: Colors.pink),
        ),
      );
    });
  }
}
