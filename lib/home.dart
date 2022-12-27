import 'package:cargpstracker/bottonTabs.dart';
import 'package:cargpstracker/dialogs/dialogs.dart';
import 'package:cargpstracker/drawer/leftDrawer.dart';
import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/user.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

enum languages { english, farsi }

class HomePage extends StatefulWidget {
  const HomePage(
      {Key? key,
      required this.userLogined,
      required this.userDevices,
      required this.currentUser})
      : super(key: key);
  final bool userLogined;
  final List<Device> userDevices;
  final User currentUser;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  final String title = 'App_Name'.tr;
  final bool switchVal = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      late Color fontColor = Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black;
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: statusColor,

              // Status bar brightness (optional)
              statusBarIconBrightness:
                  Brightness.dark, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            title: Text(title,
                style: TextStyle(color: fontColor, fontFamily: 'IranSans')),
            // iconTheme: IconThemeData(color: fontColor),
            backgroundColor: NabColor,
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => scaffoldKey.currentState!.openDrawer(),
            ),
            // status bar color
            actions: [
              IconButton(
                  icon: Icon(
                    themeNotifier.isDark
                        ? Icons.nightlight_round
                        : Icons.wb_sunny,
                    color: fontColor,
                  ),
                  onPressed: () {
                    themeNotifier.isDark
                        ? themeNotifier.isDark = false
                        : themeNotifier.isDark = true;
                    print("Theme change clicked");
                  }),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  showTimeZoneDlgBox(context);
                },
                child:
                    SvgPicture.asset("assets/timezone.svg", color: fontColor),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  showLangDlgBox(context);
                },
                child: SvgPicture.asset("assets/lang.svg", color: fontColor),
              ),
              SizedBox(width: 30),
            ]),
        body: Center(
            child: new MyStatefulWidget(
                userLogined: widget.userLogined,
                userDevices: widget.userDevices)),
        drawer: LeftDrawer(
            user: widget.currentUser,
            userLogined: widget.userLogined,
            userDevices: widget.userDevices),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
