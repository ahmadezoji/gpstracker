import 'package:cargpstracker/bottonTabs.dart';
import 'package:cargpstracker/dialogs/dialogs.dart';
import 'package:cargpstracker/drawer/leftDrawer.dart';
import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

enum languages { english, farsi }

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return MyHomePage(
        title: "App_Name".tr,
      );
    });
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final bool switchVal = false;

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('phone');
    // prefs.setString('phone', '').then((bool success) {
    //   print(success);
    // });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    print(scaffoldKey.currentState);
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
          body: const Center(
            child: MyStatefulWidget(),
          ),
          drawer: LeftDrawer());
    });
  }
}
