import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  void replaceSnackbar({
    required Widget content,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(this);
    scaffoldMessenger.removeCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(content: content),
    );
  }
}

const statusColor = Color.fromRGBO(201, 201, 201, 1.0);
const backgroundColor = Color.fromRGBO(217, 217, 217, 1.0);
const loginBackgroundColor = Color.fromRGBO(240, 246, 255, 1.0);
const NabColor = Color(0xffa500);
const backNavBarDark = Color.fromRGBO(73, 73, 73, 1.0);
const lightIconColor = Color.fromRGBO(217, 217, 217, 1.0);
const textFeildColor = Color.fromRGBO(244, 244, 244, 1.0);
const BorderSpacerColor = Color.fromRGBO(174, 174, 174, 1.0);
const ProfileheaderColor = Color.fromRGBO(44, 179, 255, 1.0);
const mapStatusColor = Color.fromRGBO(140, 140, 140, 1.0);
const vehicleCardColor = Color.fromRGBO(236, 236, 236, 1.0);
const selectedVehicleCardColor = Color.fromRGBO(70, 175, 208, 1.0);
const backPhoneNumberColor = Color.fromRGBO(222, 235, 255, 1.0);
const secondBackgroundPage = Color.fromRGBO(240, 246, 255, 1.0); //F0F6FF

class AppConstants {
  static const String LIGHT_STYLE = 'ckzcmemek003x14rwpyjekvla';
  static const String DARK_STYLE = 'cl9hrft5q000m14tnst6lreof';
  static const String SATELLITE_STYLE = 'cl9hsai8n00k115qrkkskuy8t';
  static const String mapBoxAccessToken =
      'pk.eyJ1Ijoic2FhbWV6b2ppIiwiYSI6ImNsMTNmd200MDBnb3IzZHMwaHAxM3NrZWIifQ.N4m9PiljDOPmvX-p5-Dggw';
  static const String mapBoxStyleId = LIGHT_STYLE;
}

const SHARED_PHONE_KEY = "current-user-phone-key";
const SHARED_ALLWAYS_PASS_KEY = "allways-login-with-pass";
const SHARED_REMEMBERED_PASS_KEY = "remembered-pass";

const HTTP_URL =
    'http://0.0.0.0:4680'; //'http://130.185.77.83:4681'  //'https://130.185.77.83:4681'

String getTypeAsset(String type) {
  if (type.toLowerCase().contains("car"))
    return "assets/minicar.svg";
  else if (type.toLowerCase().contains("motor"))
    return "assets/minimotor.svg";
  else if (type.toLowerCase().contains("truck"))
    return "assets/minitruck.svg";
  else if (type.toLowerCase().contains("bicycle"))
    return "assets/minibicycle.svg";
  else if (type.toLowerCase().contains("vanet"))
    return "assets/minivanet.svg";
  else
    return "assets/minicar.svg";
}
