import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/mainTabScreens/addVehicle.dart';
import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/mainTabScreens/login4.dart';
import 'package:cargpstracker/mainTabScreens/profile.dart';
import 'package:cargpstracker/mainTabScreens/setting.dart';
import 'package:cargpstracker/models/user.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cargpstracker/models/device.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer(
      {Key? key,
      required this.userLogined,
      required this.userDevices,
      required this.user})
      : super(key: key);
  final List<Device> userDevices;
  final bool userLogined;
  final User user;
  @override
  LeftDrawerState createState() => LeftDrawerState();
}

class LeftDrawerState extends State<LeftDrawer>
    with AutomaticKeepAliveClientMixin<LeftDrawer> {
  @override
  void initState() {
    super.initState();
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', '').then((bool success) {
      print(success);
    });
    // getUserDevice("09192592697").then((list) async {
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //           builder: (_) => HomePage(userLogined: false, userDevices: list!),
    //           fullscreenDialog: false));
    // });
  }

  void goToLoginPage() async {
    final prefs = await SharedPreferences.getInstance();
    String? allwaysLoginByPass = prefs.getString('allways-login-with-pass');
    if (allwaysLoginByPass == "true") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login4Page()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Widget ProfileContent() {
    return (widget.userLogined
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(image: AssetImage("assets/user_outline.png")),
              Text(widget.user.fullname,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(widget.user.phone,
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              Text(widget.user.email,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal))
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(image: AssetImage("assets/user_outline.png")),
              Text("profileContent-fullname".tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("profileContent-phone".tr,
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              Text("profileContent-email".tr,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal))
            ],
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
// Add a ListView to the drawer. This ensures the user can scroll
// through the options in the drawer if there isn't enough vertical
// space to fit everything.
      child: ListView(
// Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/backDrawer.png"),
                  opacity: 0.2,
                  fit: BoxFit.cover),
              // color: Colors.blue,
            ),
            child: ProfileContent(),
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 32),
                Text("profile".tr),
              ],
            ),
            onTap: () {
              widget.userLogined
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfilePage(userPhone: "09195835135"),
                          fullscreenDialog: false))
                  : goToLoginPage();
            },
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Icon(Icons.settings, size: 32), Text("Settings".tr)],
            ),
            onTap: () {
              widget.userLogined
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Setting(), fullscreenDialog: false))
                  : goToLoginPage();
            },
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.add_circle, size: 32),
                Text("add-new-device".tr)
              ],
            ),
            onTap: () {
              widget.userLogined
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddVehicle(),
                          fullscreenDialog: false))
                  : goToLoginPage();
            },
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.logout, size: 32),
                widget.userLogined ? Text("Logout".tr) : Text("Login".tr)
              ],
            ),
            onTap: () {
              widget.userLogined ? logout() : goToLoginPage();
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
