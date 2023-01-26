import 'package:cargpstracker/check_pattern.dart';
import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/setPattern.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GpsPlus extends StatefulWidget {
  const GpsPlus({
    Key? key,
  }) : super(key: key);

  @override
  State<GpsPlus> createState() => GpsPlusState();
}

class GpsPlusState extends State<GpsPlus>
    with AutomaticKeepAliveClientMixin<GpsPlus> {
  late bool switchLockState = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void switchChange(bool value) async {

    List<String>? savedStrList = await loadList(SHARED_SWITCH_PATTERN_KEY);
    List<int>? intProductList = savedStrList?.map((i) => int.parse(i)).toList();
    if (intProductList == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SetPattern(), fullscreenDialog: false));
    } else {
      // Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (_) =>
      //                 CheckPattern(pattern: intProductList),
      //             fullscreenDialog: false))
      //     .then((value) => print(value));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckPattern(pattern: intProductList),
        ),
      ).then((value) => changeSwitch(value));
    }
  }
  void changeSwitch(bool statue) {
    setState(() {
      switchLockState = !switchLockState;
    });
    print(switchLockState);
  }

  Widget unlock() {
    return Image.asset("assets/switch-unlock-banner.png");
  }

  Widget lock() {
    return Image.asset("assets/switch-lock-banner.jpg");
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom])
    Color backColor = Theme.of(context).brightness == Brightness.dark
        ? backNavBarDark
        : backgroundColor;

    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            new GestureDetector(
              onTap: () {
                switchChange(!switchLockState);
              },
              child: switchLockState ? lock() : unlock(),
            ),
            SizedBox(height: 40),
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

  @override
  bool get wantKeepAlive => true;
}
