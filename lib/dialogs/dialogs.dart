import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
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
                  var locale = selectedRadio == 0 ?  Locale('en', 'US') : Locale('fa', 'IR') ;
                  Get.updateLocale(locale);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      });
}

// void showLangDlgBox(BuildContext context) {
//   String? lang = "En";
//   showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         languages? currentLang = languages.english;
//         return AlertDialog(
//           title: Text("Language",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: const Text('english'),
//                 leading: Radio<languages>(
//                   value: languages.english,
//                   groupValue: currentLang,
//                   onChanged: (languages? value) {
//                     // setState(() => currentLang = value);
//                   },
//                 ),
//               ),
//               ListTile(
//                 title: const Text("فارسی"),
//                 leading: Radio<languages>(
//                   value: languages.farsi,
//                   groupValue: currentLang,
//                   onChanged: (languages? value) {
//                     currentLang = value;
//                   },
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             Container(
//               width: 100,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.blue,
//               ),
//               child: TextButton(
//                 child: Text(
//                   'Apply'.tr,
//                   style: TextStyle(fontSize: 16.0, color: Colors.white),
//                 ),
//                 // color: Colors.blueAccent,
//                 // textColor: Colors.white,
//                 onPressed: () {
//                   var locale = Locale('en', 'US');
//                   Get.updateLocale(locale);
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//           ],
//         );
//       });
// }

void showTimeZoneDlgBox(BuildContext context) {
  List<String> list = ["USA", "IRAN", "UAE", "UK"];
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Language",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: DropdownButton<String>(
                    value: "USA",
                    icon: const Icon(Icons.arrow_circle_down_sharp),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {},
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(8.0)),
                          alignment: Alignment.center,
                          width: 150,
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                  ))
            ],
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
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      });
}
