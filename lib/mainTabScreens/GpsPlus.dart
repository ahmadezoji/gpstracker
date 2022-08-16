import 'package:cargpstracker/check_pattern.dart';
import 'package:cargpstracker/setPattern.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GpsPlus extends StatelessWidget {
  const GpsPlus({Key? key}) : super(key: key);
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
    // SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom])
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            new GestureDetector(
              onTap: () {
                switchChange(context, true);
              },
              child: SvgPicture.asset(
                "assets/switch-lock2.svg",
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage("assets/speed-alarm.png")),
                Image(image: AssetImage("assets/fence-control.png"))
              ],
            )
          ],
        ),
      );
    });
  }
}
