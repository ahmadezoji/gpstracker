import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

enum languages { english, farsi }

void showLangDlgBox(BuildContext context) {
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        int? selectedRadio = 0;
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('english'),
                    leading: Radio<int>(
                      value: 0,
                      groupValue: selectedRadio,
                      onChanged: (int? value) {
                        setState(() => selectedRadio = value);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text("فارسی"),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: selectedRadio,
                      onChanged: (int? value) {
                        setState(() => selectedRadio = value);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              child: TextButton(
                child: Text(
                  'Apply'.tr,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                // color: Colors.blueAccent,
                // textColor: Colors.white,
                onPressed: () {
                  var locale = selectedRadio == 0
                      ? Locale('en', 'US')
                      : Locale('fa', 'IR');
                  Get.updateLocale(locale);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      });
}

void showTimeZoneDlgBox(BuildContext context) {
  List<String> list = ["USA", "IRAN", "UAE", "UK"];
  Color backColor = Theme.of(context).brightness == Brightness.dark
      ? backNavBarDark
      : backgroundColor;
  Color fontColor = Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Colors.black;
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String? selectedZone = "";
        return AlertDialog(
          title: Text("timezone".tr,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 20,
                    style: const TextStyle(color: Colors.blue, fontSize: 14),
                    // underline: Container(
                    //   height: 2,
                    //   color: Colors.deepPurpleAccent,
                    // ),
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: selectedZone,
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: backColor,
                              borderRadius: BorderRadius.circular(8.0)),
                          alignment: Alignment.center,
                          width: 200,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/ellipse.svg',
                                ),
                                Text(
                                  value,
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      print(newValue);
                      setState(() => selectedZone = newValue);
                    },
                  )
                ],
              );
            },
          ),
          actions: [
            Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              child: TextButton(
                child: Text(
                  'Apply'.tr,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                // color: Colors.blueAccent,
                // textColor: Colors.white,
                onPressed: () {
                  print(selectedZone);
                  // Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      });
}

//
// StatefulBuilder(
// builder: (BuildContext context, StateSetter setState)
// {
// return  DropdownButton<String>(
// icon: const Icon(Icons.arrow_drop_down),
// elevation: 20,
// style: const TextStyle(color: Colors.blue,fontSize: 14),
// // underline: Container(
// //   height: 2,
// //   color: Colors.deepPurpleAccent,
// // ),
// items: list.map<DropdownMenuItem<String>>((String value) {
// return DropdownMenuItem<String>(
// value: selectedZone,
// alignment: Alignment.center,
// child: Container(
// margin: EdgeInsets.all(2),
// decoration: BoxDecoration(
// color: backColor,
// borderRadius: BorderRadius.circular(8.0)
// ),
// alignment: Alignment.center,
// width: 200,
// child: Padding(
// padding: EdgeInsets.only(left: 5,right: 5),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// SvgPicture.asset(
// 'assets/ellipse.svg',
// ),
// Text(value,style: TextStyle(fontSize: 12),)
// ],
// ),
// ),
// ),
// );
// }).toList(),
// onChanged: (String? newValue) {
// print(newValue);
// setState(() => selectedZone = newValue);
// },
// );
// }
// ),
