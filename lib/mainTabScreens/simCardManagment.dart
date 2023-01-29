import 'dart:convert';
import 'dart:core';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:cargpstracker/allVehicle.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cargpstracker/mainTabScreens/login2.dart';
import 'package:cargpstracker/mainTabScreens/otpCode.dart';
import 'package:cargpstracker/myRequests.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ussd_service/ussd_service.dart';
import 'package:permission_handler/permission_handler.dart';

class SimCardPage extends StatefulWidget {
  const SimCardPage(
      {Key? key,
      required this.userLogined,
      required this.userDevices,
      required this.currentUser})
      : super(key: key);
  final List<Device> userDevices;
  final bool userLogined;
  final User currentUser;

  @override
  _SimCardPageState createState() => _SimCardPageState();
}

class _SimCardPageState extends State<SimCardPage>
    with AutomaticKeepAliveClientMixin<SimCardPage> {
  late List<Device> _listDevice = widget.userDevices;
  String SimNumber = "+9";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onSelectedDevice(int deviceIndex) async {
    setState(() {
      SimNumber = _listDevice.elementAt(deviceIndex).simPhone;
    });
    makeMyRequest();
  }

  void makeMyRequest() async {
    print('code');
    await Permission.phone.request();
    if (!await Permission.phone.isGranted) {
      throw Exception("permission missing");
    }
    int subscriptionId = 2; // sim card subscription Id
    String code =
        "*123#"; //"*140*11#";//"*123#" #turkcell remian; // ussd code payload
    print(code);
    try {
      String ussdSuccessMessage =
          await UssdService.makeRequest(subscriptionId, code);
      print("succes! message: $ussdSuccessMessage");
    } on PlatformException catch (e) {
      print("error! code: ${e.code} - message: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(title: Text("Sim Management".tr)),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          scrollDirection: Axis.vertical,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              myAllVehicle(
                selectedDevice: _onSelectedDevice,
                userLogined: widget.userLogined,
                userDevices: _listDevice,
                currentUser: widget.currentUser,
              ),
              SizedBox(
                height: 100,
              ),
              Text('Phone number synced with GPS+',
                  style: TextStyle(fontSize: 12)),
              Text(
                '$SimNumber',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Balance: ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text('54710 IRR'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remaining Internet Value: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('7.13 GB'),
                ],
              ),
              SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: backRechargBtn),
                    child: Text('Recharge'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      makeMyRequest();
                    },
                    child: Container(
                      height: 120,
                      width: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: backRechargBtn),
                      child: Text('Buy Internet '),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
