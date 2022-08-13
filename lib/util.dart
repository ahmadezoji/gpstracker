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
const NabColor = Color(0xffa500);
const lightIconColor = Color.fromRGBO(217, 217, 217, 1.0);
const textFeildColor = Color.fromRGBO(244,244,244, 1.0);
