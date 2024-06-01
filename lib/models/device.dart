import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Device {
  String deviceId; // represents the device remote id
  String name;
  int? rssi;

  Device({required this.deviceId, required this.name, this.rssi});

  // Use to receive devices from the backend
  factory Device.fromJson(Map<String, dynamic> map) {
    return Device(
      deviceId: map['deviceId'],
      name: map['name'],
    );
  }

  factory Device.fromScanResult(ScanResult scanResult) {
    return Device(
      deviceId: scanResult.device.remoteId.toString(),
      name: scanResult.device.platformName ?? 'Unknown',
      rssi: scanResult.rssi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'name': name,
      'rssi': rssi ?? 0,
    };
  }
}
