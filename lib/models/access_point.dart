import 'package:wifi_scan/wifi_scan.dart';

class AccessPoint {
  final String ssid;
  final String bssid;
  final double quality;

  AccessPoint({
    required this.ssid,
    required this.bssid,
    required this.quality,
  });

  factory AccessPoint.fromMap(Map<String, dynamic> map) {
    return AccessPoint(
      ssid: map['ssid'],
      bssid: map['bssid'],
      quality: map['quality'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ssid': ssid,
      'bssid': bssid,
      'quality': quality,
    };
  }

  factory AccessPoint.fromWifiAccessPoint(WiFiAccessPoint wifiAccessPoint) {
    return AccessPoint(
      ssid: wifiAccessPoint.ssid,
      bssid: wifiAccessPoint.bssid,
      quality: convertDbmToRssi(dbm: wifiAccessPoint.level),
    );
  }

  static double convertDbmToRssi({required int dbm}) {
    return (2 * (dbm + 100)).clamp(0, 100).toDouble();
  }
}
