import 'package:cargpstracker/mainTabScreens/GpsPlus.dart';
import 'package:cargpstracker/mainTabScreens/history.dart';
import 'package:cargpstracker/mainTabScreens/live.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
// import 'firebase_options.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({
    Key? key,
  }) : super(key: key);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    late bool isDark = Theme.of(context).brightness == Brightness.dark;
    late Color selectedFontColor = isDark ? Colors.white : Colors.black;
    late Color unselectedFontColor = isDark ? Colors.white : Colors.black;
    late Color backColor = isDark ? backNavBarDark : backgroundColor;
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        // body: Center(
        //   child: _widgetOptions.elementAt(_selectedIndex),
        // ),
        body: IndexedStack(
          children: const <Widget>[GpsPlus(), Live(), History()],
          index: _selectedIndex,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: backColor,
          items: <BottomNavigationBarItem>[
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
          selectedLabelStyle: TextStyle(color: Colors.red, fontSize: 16),
          unselectedFontSize: 16,
          onTap: (value) => setState(() {
            _selectedIndex = value;
          }),
          selectedIconTheme:
              IconThemeData(color: Colors.blue, opacity: 1.0, size: 30.0),
          unselectedItemColor: unselectedFontColor,
          unselectedLabelStyle: TextStyle(fontSize: 18, color: Colors.pink),
        ),
      );
    });
  }
}
