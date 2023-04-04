import 'dart:core';

import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/theme_model.dart';
import 'package:cargpstracker/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> with TickerProviderStateMixin {
  Locale? _local;
  String currentLanguage = "";
  @override
  void initState() {
    super.initState();
    _local = Get.deviceLocale!;

    print(_local);
    print(locale.keys.elementAt(0));

    print(locale_string[_local.toString()]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("language".tr),
        ),
        body: LayoutBuilder(
            builder: (context, constraints) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: locale.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 50,
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Text(locale.keys.elementAt(index)),
                                      locale_string[_local.toString()] ==
                                              locale.keys.elementAt(index)
                                          ? Icon(Icons.check)
                                          : Text('')
                                    ],
                                  ),
                                );
                              })),
                    ),
                  ],
                )),
      );
    });
  }
}
