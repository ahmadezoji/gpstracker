import 'package:cargpstracker/mainTabScreens/addVehicle.dart';
import 'package:cargpstracker/mainTabScreens/profile.dart';
import 'package:cargpstracker/mainTabScreens/setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({Key? key}) : super(key: key);

  @override
  LeftDrawerState createState() => LeftDrawerState();
}

class LeftDrawerState extends State<LeftDrawer>
    with AutomaticKeepAliveClientMixin<LeftDrawer> {
  @override
  void initState() {
    super.initState();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(image: AssetImage("assets/user_outline.png")),
                Text("saam ezoji",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("+905346403281",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                Text("saam.ezoji@gmailcm",
                    style:
                    TextStyle(fontSize: 12, fontWeight: FontWeight.normal))
              ],
            ),
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 32),
                Text("   Profile".tr),
              ],
            ),
            onTap: () {Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfilePage(userPhone: "09195835135"), fullscreenDialog: false));},
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Icon(Icons.settings, size: 32), Text("   Setting".tr)],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Setting(), fullscreenDialog: false));
            },
          ),
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.add_circle, size: 32),
                Text("   Add new device".tr)
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddVehicle(), fullscreenDialog: false));
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
