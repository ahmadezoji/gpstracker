import 'dart:convert' as convert;

import 'package:cargpstracker/models/device.dart';
import 'package:http/http.dart' as http;

Future<List<Device>?> getUserDevice(String phone) async {
  try {
    List<Device> devicesList = [];

    // ignore: unnecessary_null_comparison
    if (phone == null) return null;
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://130.185.77.83:4680/getDeviceByUser/'));
    request.fields.addAll({
      'phone': phone,
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);

      for (var dev in json) {
        Device device = Device.fromJson(dev);
        devicesList.add(device);
      }
      return devicesList;
    } else {
      return null;
    }
  } catch (error) {
    return null;
  }
}
