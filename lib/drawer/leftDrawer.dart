
import 'package:cargpstracker/autentication.dart';
import 'package:cargpstracker/home.dart';
import 'package:cargpstracker/mainTabScreens/addVehicle.dart';
import 'package:cargpstracker/mainTabScreens/login.dart';
import 'package:cargpstracker/mainTabScreens/login4.dart';
import 'package:cargpstracker/mainTabScreens/profile.dart';
import 'package:cargpstracker/mainTabScreens/setting.dart';
import 'package:cargpstracker/mainTabScreens/shared.dart';
import 'package:cargpstracker/mainTabScreens/signOn.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer(
      {Key? key,
      required this.userLogined,
      required this.userDevices,
      required this.currentUser})
      : super(key: key);
  final List<Device> userDevices;
  final bool userLogined;
  final myUser currentUser;

  @override
  LeftDrawerState createState() => LeftDrawerState();
}

class LeftDrawerState extends State<LeftDrawer>
    with AutomaticKeepAliveClientMixin<LeftDrawer> {
  late myUser _currentUser = widget.currentUser;

  @override
  void initState() {
    super.initState();
  }
  void logout() async {
    delete(SHARED_PHONE_KEY);
    try {
      await Authentication.signOut();
      // List<Device> devicesList = (await getUserDevice("09192592697"))!;
      // User currentUser = await getUser("09192592697") as User;
      // if (devicesList != null && currentUser != null) {
      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //           builder: (_) => HomePage(
      //               currentUser: currentUser,
      //               userLogined: false,
      //               userDevices: devicesList),
      //           fullscreenDialog: false));
      // }
      // goToLoginPage();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => new SignOnPage()),
      );
    } catch (e) {
      print(e);
    }
  }

  void goToLoginPage() async {
    String? withPass = await load(SHARED_ALLWAYS_PASS_KEY);
    if (withPass == "true") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Login4Page(
                currentUser: _currentUser, userDevices: widget.userDevices)),
      );
    } else {
      Navigator.pushReplacement(
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
              _currentUser.pictureUrl == ""
                  ? Image(image: AssetImage("assets/user_outline.png"))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(35.0),
                      child: Image.network(
                        _currentUser.pictureUrl,
                        height: 70.0,
                        width: 70.0,
                      ),
                    ),
              SizedBox(
                height: 5,
              ),
              _currentUser.fullname == ""
                  ? Text("profileContent-fullname".tr,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                  : Text(_currentUser.fullname,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              _currentUser.phone == ""
                  ? Text("profileContent-phone".tr,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal))
                  : Text(_currentUser.phone,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
              _currentUser.email == ""
                  ? Text("profileContent-email".tr,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal))
                  : Text(_currentUser.email,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal))
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

  void onRefresh(myUser user) async {
    print(user);
    setState(() {
      _currentUser = user;
    });
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
              print('widget.userLogined = ${widget.userLogined}');
              widget.userLogined
                  ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfilePage(
                                    currentUser: _currentUser,
                                  ),
                              fullscreenDialog: false))
                      .then((value) => onRefresh(value.user))
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
                        builder: (_) => Setting(
                            currentUser: widget.currentUser,
                            userDevices: widget.userDevices),
                        fullscreenDialog: false,
                      ))
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
                          builder: (_) => AddVehicle(currentUser: _currentUser),
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
