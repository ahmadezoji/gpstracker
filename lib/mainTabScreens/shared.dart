import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<bool> save(String key, String val) async {
  final prefs = await SharedPreferences.getInstance();
  return await prefs.setString(key, val);
}

Future<bool> delete(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return await prefs.remove(key);
}

Future<String?> load(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<bool> saveJson(String key, Map<String, dynamic> val) async {
  final prefs = await SharedPreferences.getInstance();
  return await prefs.setString(key, jsonEncode(val));
}

Future<Map<String, dynamic>?>? loadJson(String key) async {
  final prefs = await SharedPreferences.getInstance();
  String? str = prefs.getString(key);
  print(str);
  if (str == null)
    return null;
  else
    return jsonDecode(str) as Map<String, dynamic>;
}
