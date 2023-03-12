import 'dart:core';

import 'package:cargpstracker/allVehicle.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SimCardPage extends StatefulWidget {
  const SimCardPage({
    Key? key,
  }) : super(key: key);

  @override
  _SimCardPageState createState() => _SimCardPageState();
}

class _SimCardPageState extends State<SimCardPage>
    with AutomaticKeepAliveClientMixin<SimCardPage> {

  String _simNumber = "";

  // late Device _currentDevice = widget.currentDeveice;
  Future<void> _onSelectedDevice(Device device) async {
    setState(() {
      _simNumber = device.simPhone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(title: Text("Sim Management".tr)),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              myAllVehicle(
                  selectedDevice: _onSelectedDevice,
                  selectedDeviceIndex: 0,
                  direction: VehicleTooltipDirection.DOWN),
              buildSimCardView(_simNumber),
            ],
          ),
        ),
      );
    });
  }

  Widget buildSimCardView(String simNumber) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      scrollDirection: Axis.vertical,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Phone number synced with GPS+', style: TextStyle(fontSize: 12)),
          Text(
            '$simNumber',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
                  // makeMyRequest();
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
