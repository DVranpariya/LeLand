import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info/device_info.dart';

class InitialData {
  double latitude, longitude;
  String deviceToken;
  int deviceType;
  var deviceID;

  Future<void> getDeviceTypeId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      deviceType = 0;
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceID = androidDeviceInfo.androidId;
      // print('Device Type: ${deviceType.toString()}, ' + 'Device ID: $deviceID');
    } else {
      deviceType = 1;
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceID = iosDeviceInfo.identifierForVendor;
      // print('Device Type: ${deviceType.toString()}, ' + 'Device ID: $deviceID');
    }
  }

  getDeviceToken() {
    var random = Random();
    var values = List<int>.generate(200, (i) => random.nextInt(255));
    deviceToken = base64UrlEncode(values);
    // print('Device Token: ' + deviceToken);
  }
}
