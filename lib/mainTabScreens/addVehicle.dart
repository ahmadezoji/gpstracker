// import 'package:cargpstracker/mainTabScreens/qrScanner.dart';
import 'dart:collection';
import 'dart:convert';
import 'dart:core';

import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddVehicle extends StatefulWidget {
  const AddVehicle({Key? key}) : super(key: key);

  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle>
    with AutomaticKeepAliveClientMixin<AddVehicle> {
  late String serial;
  late String deviceSimNum;
  late String type = "minicar";
  static Map<String, String> devices = {
    "car".tr: 'minicar',
    "motor".tr: "minimotor",
    "truck".tr: "minitruck"
  };

  @override
  void initState() {
    super.initState();
    // print('initState Live');
    // devices.add(Text('asdsd'));
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle kStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w900,
    );

    void addDevice() async {
      try {
        var request = http.MultipartRequest(
            'POST', Uri.parse('https://130.185.77.83:4680/addDevice/'));
        request.fields.addAll({
          'serial': serial,
          'userNum': 'widget.userPhone',
          'deviceSimNum': deviceSimNum
        });

        http.StreamedResponse response = await request.send();
        print(response.statusCode);
        if (response.statusCode == 200) {
          final responseData = await response.stream.toBytes();
          final responseString = String.fromCharCodes(responseData);
          print(responseString);
          final json = jsonDecode(responseString);
          // if (json != null) {
          //   Fluttertoast.showToast(msg: "add-user-msg".tr);
          //   Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //           builder: (_) => HomePage(), fullscreenDialog: false));
          // }
        } else {
          print(response.reasonPhrase);
        }
      } catch (error) {}

      //  Navigator.push(
      // context, MaterialPageRoute(builder: (_) => HomePage()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 50.0, bottom: 10),
                // padding: EdgeInsets.symmetric(horizontal: 60),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) => setState(() {
                          serial = value;
                        }),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          filled: true,
                          fillColor: textFeildColor,
                          labelText: "Serial".tr,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) => setState(() {
                          serial = value;
                        }),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          filled: true,
                          fillColor: textFeildColor,
                          hintText: "+98",
                          labelText: "SimCard Number".tr,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        onChanged: (value) => setState(() {
                          serial = value;
                        }),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          filled: true,
                          fillColor: textFeildColor,
                          labelText: "Car Name".tr,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: DropdownButton<String>(
                        items: devices
                            .map((description, value) {
                              return MapEntry(
                                  description,
                                  DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      height: 70,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            //                    <--- top side
                                            color: BorderSpacerColor,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      width: 250,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/ellipse.svg',
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              SvgPicture.asset(
                                                'assets/$value.svg',
                                              ),
                                            ],
                                          ),
                                          Text(description)
                                        ],
                                      ),
                                    ),
                                  ));
                            })
                            .values
                            .toList(),
                        value: type,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              type = newValue;
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: TextButton(
                          child: Text(
                            'Apply'.tr,
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                          // color: Colors.blueAccent,
                          // textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    bool _debugLocked =
        false; // used to prevent re-entrant calls to push, pop, and friends
    assert(!_debugLocked);
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) =>  QrScannerPage()),
    // );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text('$result')));
  }

  @override
  bool get wantKeepAlive => true;
}
