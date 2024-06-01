import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mobile/models/device.dart';
import 'package:mobile/services/logger_service.dart';

class BleService {
  final logger = LoggerService.logger;

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

    return devices;
  }
}
