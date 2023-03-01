import 'dart:core';

import 'package:cargpstracker/bottonTabs.dart';
import 'package:cargpstracker/dialogs/dialogs.dart';
import 'package:cargpstracker/drawer/leftDrawer.dart';
import 'package:cargpstracker/mainTabScreens/simCardManagment.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

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
  final myUser currentUser;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  late String title = "app_name".tr;
  final bool switchVal = false;
  late List<Device> _listDevice = widget.userDevices;
  late myUser _user = widget.currentUser;


  @override
  void initState() {
    super.initState();
    _listDevice = widget.userDevices;
    _user = widget.currentUser;
  }

  void _onSimMangment() async {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (_) => SimCardPage(
    //               currentUser: _user,
    //               userDevices: _listDevice,
    //               userLogined: false,
    //               selectedDeviceIndex: 0,
    //             ),
    //         fullscreenDialog: false));
  }

  void onRefresh() async {
    try {
      myUser tmpUser = (await getUser(widget.currentUser.email))!;
      List<Device> tempArray = (await getUserDevice(widget.currentUser))!;
      setState(() {
        _listDevice = tempArray;
        _user = tmpUser;
      });
      print(_listDevice);
    } catch (error) {
      print('refresh = $error');
    }
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
            // backgroundColor: NabColor,
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => scaffoldKey.currentState!.openDrawer(),
            ),
            // status bar color
            actions: [
              IconButton(
                icon: SvgPicture.asset("assets/simcard-icon.svg"),
                onPressed: () => _onSimMangment(),
              ),
              SizedBox(width: 10),
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
              IconButton(
                icon: SvgPicture.asset("assets/lang.svg", color: fontColor),
                onPressed: () => showLangDlgBox(context),
              ),
              // SizedBox(width: 10),
              // IconButton(
              //     icon: Icon(Icons.refresh),
              //     onPressed: () {
              //       onRefresh();
              //     }),
              SizedBox(width: 10),
            ]),
        body: Center(
            child: new MyStatefulWidget(
          userLogined: widget.userLogined,
          userDevices: _listDevice,
          currentUser: _user,
        )),
        drawer: LeftDrawer(
            currentUser: _user,
            userLogined: widget.userLogined,
            userDevices: _listDevice),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
