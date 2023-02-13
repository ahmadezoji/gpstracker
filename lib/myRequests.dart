import 'dart:convert' as convert;

import 'package:cargpstracker/models/config.dart';
import 'package:cargpstracker/models/device.dart';
import 'package:cargpstracker/models/myUser.dart';
import 'package:cargpstracker/util.dart';
import 'package:cargpstracker/models/point.dart';
import 'package:http/http.dart' as http;

Future<bool?> setCommand(Device device, String cmnd) async {
  try {
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/setCommand/'));
    request.fields.addAll({'serial': device.serial, 'command': cmnd});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      print(json);
      return json["status"];
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<bool?> OTPverifyNew(String userPhone) async {
  try {
    if (userPhone.isEmpty) {
      return null;
    }
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/phoneVerifyNew/'));
    request.fields.addAll({'phone': userPhone});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      print(json);
      return json["status"];
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<String?> OTPverify(String userPhone) async {
  try {
    if (userPhone.isEmpty) {
      return null;
    }
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/phoneVerify/'));
    request.fields.addAll({'phone': userPhone});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      print(json);
      if (json["status"] == true) {
        return json["code"];
      }
    } else {
      return null;
    }
  } catch (error) {
    return null;
  }
}

Future<myUser?> addUser(myUser user) async {
  try {
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/addUser/'));
    request.fields.addAll({
      'phone': user.phone,
      'fullname': user.fullname,
      'email': user.email,
      'birthday': user.birthday,
      'pictureUrl': user.pictureUrl,
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      print('json = $json');
      if (json != null) {
        return myUser.fromJson(json);
      } else {
        return null;
      }
    } else {
      print(response.reasonPhrase);
      return null;
    }
  } catch (error) {
    print(error.toString());
    return null;
  }
}

Future<myUser?> getUser(String email) async {
  try {
    if (email.isEmpty) return null;
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/getUser/'));
    request.fields.addAll({
      'email': email,
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      print('json = $json');
      return myUser.fromJson(json);
    } else {
      return null;
    }
  } catch (error) {
    print(error);
    return null;
  }
}

Future<List<Device>?> getUserDevice(myUser user) async {
  try {
    List<Device> devicesList = [];
    if (user.email.isEmpty) return null;

    // ignore: unnecessary_null_comparison
    if (user.email == null) return null;
    var request = http.MultipartRequest(
        'POST', Uri.parse(HTTP_URL + '/getDeviceByUser/'));
    request.fields.addAll({
      'email': user.email,
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

Future<bool?> addDevice(Device device, myUser user) async {
  try {
    List<Device> devicesList = [];
    if (user.email.isEmpty || device.serial.isEmpty) return null;
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/addDevice/'));
    request.fields.addAll({
      'serial': device.serial,
      'userEmail': user.email,
      'deviceSimNum': device.simPhone,
      'type': device.type,
      'title': device.title
    });
    print('user.email=${user.email}');
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      print(json);
      return json["status"] as bool;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<bool?> updatePass(myUser user, String password) async {
  try {
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/updatePass/'));
    request.fields.addAll({'email': user.email, 'password': password});

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      return json["status"] as bool;
    } else {
      return false;
    }
  } catch (error) {
    print('error = $error');
    return false;
  }
}

Future<bool?> updateDevice(Device device) async {
  try {
    if (device.serial.isEmpty) return null;
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/updateDevice/'));
    request.fields.addAll({
      'serial': device.serial,
      'deviceSimNum': device.simPhone,
      'type': device.type,
      'title': device.title
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      print(json);
      return json["status"] as bool;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<bool?> deleteDevice(Device device) async {
  try {
    if (device.serial.isEmpty) return null;
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/deleteDevice/'));
    request.fields.addAll({
      'serial': device.serial,
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      return json["status"] as bool;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<myUser?> updateUser(myUser user) async {
  try {
    if (user.email.isEmpty) return null;
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/updateUser/'));
    request.fields.addAll({
      'phone': user.phone,
      'email': user.email,
      'birthday': user.birthday,
      'fullname': user.fullname,
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      print(json);
      return myUser.fromJson(json);
    } else {
      return null;
    }
  } catch (error) {
    return null;
  }
}

Future<bool?> loginWithPass(String email, String password) async {
  try {
    if (email.isEmpty) return null;
    if (password.isEmpty) return null;
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/loginByPass/'));
    request.fields.addAll({
      'email': email,
      'password': password,
    });
    print(request);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      return json["status"];
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<Point?> getCurrentLocation(Device currentDevice) async {
  try {
    var request = http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/live/'));
    request.fields.addAll({'serial': currentDevice.serial});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      return Point.fromJson(json["features"][0]);
    } else {
      print(response.reasonPhrase);
    }
  } catch (error) {
    return null;
  }
  return null;
}

Future<Config?> getConfig(Device device) async {
  try {
    if (device.serial.isEmpty) return null;
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/getConfig/'));
    request.fields.addAll({
      'serial': device.serial,
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      print(json);
      return Config.fromJson(json);
    } else {
      return null;
    }
  } catch (error) {
    print('error = $error');
    return null;
  }
}

Future<bool?> setConfig(Device device, Config config) async {
  try {
    if (device.serial.isEmpty) return null;
    var request =
        http.MultipartRequest('POST', Uri.parse(HTTP_URL + '/setConfig/'));
    request.fields.addAll({
      'serial': device.serial,
      'language': config.language,
      'timezone': config.timezone,
      'interval': config.intervalTime.toString(),
      'static': config.staticTime.toString(),
      'speed_alarm': config.speed_alarm.toString(),
      'fence': config.fence,
      'userPhoneNum': config.userPhoneNum,
      'apn_name': config.apn_name,
      'apn_user': config.apn_user,
      'apn_pass': config.apn_pass,
      'alarming_method': config.alarming_method.toString(),
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = convert.jsonDecode(responseString);
      return json["status"];
    } else {
      return false;
    }
  } catch (error) {
    print('error = $error');
    return false;
  }
}
