import 'package:logger/logger.dart';
import 'package:mobile/models/access_point.dart';
import 'package:mobile/services/logger_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiService {
  final WiFiScan wifiScan = WiFiScan.instance;
  final Logger logger = LoggerService.logger;

  Future<List<AccessPoint>> getAccessPoints() async {
    logger.i("Started wifi scan");

    PermissionStatus locationPermission = await Permission.location.request();
    if (!locationPermission.isGranted) {
      logger.w("Location permission not granted");
    }

    // From Android 13 and above
    // PermissionStatus nearbyWifiDevicesPermission =
    //     await Permission.nearbyWifiDevices.request();
    // if (!nearbyWifiDevicesPermission.isGranted) {
    //   logger.w("Nearby wifi devices permission not granted");
    // }
    final canStartScan =
        await WiFiScan.instance.canStartScan(askPermissions: true);

    if (canStartScan == CanStartScan.yes) {
      final isScanning = await WiFiScan.instance.startScan();

      if (!isScanning) {
        logger.w("Wifi scan not started");
        return [];
      }

      final can =
          await WiFiScan.instance.canGetScannedResults(askPermissions: true);
      switch (can) {
        case CanGetScannedResults.yes:
          final accessPoints = await WiFiScan.instance.getScannedResults();

          List<AccessPoint> aps = accessPoints
              .map((wifiAccessPoint) =>
                  AccessPoint.fromWifiAccessPoint(wifiAccessPoint))
              .toList();

          return aps;

        case CanGetScannedResults.notSupported:
          logger.w("Scanning not supported");
          return [];

        case CanGetScannedResults.noLocationPermissionRequired:
          logger.w("Location permission required");
          return [];

        case CanGetScannedResults.noLocationPermissionDenied:
          logger.w("Location permission denied");
          return [];

        case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
          logger.w("Location permission upgrade accuracy");
          return [];

        case CanGetScannedResults.noLocationServiceDisabled:
          logger.w("Location service disabled");
          return [];
      }
    }

    logger.w("Cannot start wifi scan");
    return [];
  }
}
