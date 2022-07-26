import 'dart:convert';

class Device {
  final String serial;
  final String simPhone;
  final String title;
  final String type;

  const Device({
    required this.serial,
    required this.title,
    required this.simPhone,
    required this.type,
  });

  String getSerial() {
    return this.serial;
  }

  String getSimPhone() {
    return this.simPhone;
  }

  String getTitle() {
    return this.title;
  }

  String getType() {
    return this.type;
  }

  factory Device.fromJson(Map<String, dynamic> jsonData) {
    return Device(
      serial: jsonData['serial'],
      title: jsonData['title'],
      simPhone: jsonData['simPhone'],
      type: jsonData["type"],
    );
  }
  @override
  String toString() {
    return 'device = ${title} , ${serial}';
  }

  static Map<String, dynamic> toMap(Device device) => {
        'serial': device.serial,
        'title': device.title,
        'simPhone': device.simPhone,
        'type': device.type
      };

  static String encode(List<Device> devices) => json.encode(
        devices
            .map<Map<String, dynamic>>((devices) => Device.toMap(devices))
            .toList(),
      );

  static List<Device> decode(String devices) =>
      (json.decode(devices) as List<dynamic>)
          .map<Device>((item) => Device.fromJson(item))
          .toList();
}
