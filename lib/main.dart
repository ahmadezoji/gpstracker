import 'package:cargpstracker/LacaleString.dart';
import 'package:cargpstracker/mainTabScreens/history.dart';
import 'package:cargpstracker/mainTabScreens/setting.dart';
import 'package:cargpstracker/bottonTabs.dart';
import 'package:cargpstracker/mainTabScreens/start.dart';
import 'package:cargpstracker/spalshScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String ACCESS_TOKEN =
      'pk.eyJ1IjoiYWhtYWQtZXpvamkiLCJhIjoiY2s4bXlmc3RhMDczaTNob3c2YTF0a3YwdyJ9.xk8OyD77TanRLKtKqal1rQ';
  static const appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LocaleString(),
      locale: Locale('fa','IR'),
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
