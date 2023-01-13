import 'dart:convert';

class Config {
  late String device_id;
  late String language;
  late String timezone;
  late int intervalTime;
  late int staticTime;
  late int speed_alarm;
  late String fence;
  late String userPhoneNum;
  late String apn_name;
  late String apn_user;
  late String apn_pass;
  late int alarming_method;

  Config({
    required this.device_id,
    required this.language,
    required this.timezone,
    required this.intervalTime,
    required this.staticTime,
    required this.speed_alarm,
    required this.fence,
    required this.userPhoneNum,
    required this.apn_name,
    required this.apn_user,
    required this.apn_pass,
    required this.alarming_method,
  });
  factory Config.fromJson(Map<String, dynamic> jsonData) {
    return Config(
      device_id: jsonData['serial'],
      language: jsonData['language'],
      timezone: jsonData['timezone'],
      intervalTime: jsonData['interval'],
      staticTime: jsonData['static'],
      speed_alarm: jsonData['speed_alarm'],
      fence: jsonData['fence'] == null ? '' : jsonData['fence'],
      userPhoneNum:
          jsonData['userPhoneNum'] == null ? '' : jsonData['userPhoneNum'],
      apn_name: jsonData['apn_name'] == null ? '' : jsonData['apn_name'],
      apn_user: jsonData['apn_user'] == null ? '' : jsonData['apn_user'],
      apn_pass: jsonData['apn_pass'] == null ? '' : jsonData['apn_pass'],
      alarming_method: jsonData['alarming_method'],
    );
  }
  @override
  String toString() {
    return 'language =$language , timeZone= $timezone, interval = $intervalTime , static = $staticTime';
  }

  static List<Config> decode(String devices) =>
      (json.decode(devices) as List<dynamic>)
          .map<Config>((item) => Config.fromJson(item))
          .toList();
}
