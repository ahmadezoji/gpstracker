import 'dart:convert';

class Device {
  final String serial;
  final String userPhone;
  final String title;

  const Device({
    required this.serial,
    required this.title,
    required this.userPhone,
  });

  String getSerial() {
    return this.serial;
  }

  String getUserPhone() {
    return this.userPhone;
  }

  String getTitle() {
    return this.title;
  }


  factory Device.fromJson(Map<String, dynamic> jsonData) {
    return Device(
      serial: jsonData['serial'],
      title: jsonData['title'],
      userPhone: jsonData['usePhone'],
    );
  }

  static Map<String, dynamic> toMap(Device device) =>
      {
        'serial': device.serial,
        'title': device.title,
        'userPhone': device.userPhone
      };

  static String encode(List<Device> devices) =>
      json.encode(
        devices
            .map<Map<String, dynamic>>((devices) => Device.toMap(devices))
            .toList(),
      );

  static List<Device> decode(String devices) =>
      (json.decode(devices) as List<dynamic>)
          .map<Device>((item) => Device.fromJson(item))
          .toList();
}