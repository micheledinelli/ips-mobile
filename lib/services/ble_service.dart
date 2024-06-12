import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mobile/models/device.dart';
import 'package:mobile/services/logger_service.dart';
import 'dart:math' as Math;

class BleService {
  final logger = LoggerService.logger;
  final M = -54;
  final gamma = 3.0;

  num estimateDistance(int rss, int m, double gamma) {
    return Math.pow(10, (m - rss) / (10 * gamma));
  }

  Future<List<Device>> getBleDevices() async {
    logger.i("Started BLE scan");
    if (await FlutterBluePlus.isSupported == false) {
      logger.w("Bluetooth not supported by this device");
      return [];
    }

    FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 4),
        continuousUpdates: true,
        androidUsesFineLocation: true,
        removeIfGone: const Duration(seconds: 3));

    List<ScanResult> scanResults = FlutterBluePlus.lastScanResults;

    List<Device> devices = scanResults
        .map((scanResult) => Device.fromScanResult(scanResult))
        .toList();

    // Filter out the devices with estimated distance > 2m
    devices = devices
        .where((device) => estimateDistance(device.rssi!, M, gamma) <= 2.0)
        .toList();

    return devices;
  }
}
