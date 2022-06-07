import 'package:cargpstracker/LacaleString.dart';
import 'package:cargpstracker/spalshScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String ACCESS_TOKEN =
      'pk.eyJ1Ijoic2FhbWV6b2ppIiwiYSI6ImNsNDJvZ3RoeTB1NWMzZG82YnVodGU1d2EifQ.x3z9Smy3JJcwy-bNzHsZ6A';
  static const appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LocaleString(),
      locale: Locale('en','US'),
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: SpalshScreen(),
    );
    // return  MaterialApp(
    //   title: appTitle,
    //   home: SpalshScreen(),
    // );
  }
}
