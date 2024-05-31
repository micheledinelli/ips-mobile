import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mobile/services/logger_service.dart';

class BleService {
  final logger = LoggerService.logger;

  Future<List<ScanResult>> getBleDevices() async {
    if (await FlutterBluePlus.isSupported == false) {
      logger.w("Bluetooth not supported by this device");
      return [];
    }

    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 4), androidUsesFineLocation: true);

    return FlutterBluePlus.lastScanResults;
  }
}
