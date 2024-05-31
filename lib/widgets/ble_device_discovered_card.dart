import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleDeviceDiscoveredCard extends StatelessWidget {
  final ScanResult device;
  final bool isNearby;

  const BleDeviceDiscoveredCard(
      {required this.device, required this.isNearby, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: _buildIcon(device.rssi),
              title: Text(
                device.device.remoteId.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                'RSSI: ${device.rssi}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(int rssi) {
    IconData iconData;
    Color color;
    if (rssi > -50) {
      iconData = Icons.bluetooth;
      color = Colors.green;
    } else if (rssi > -70) {
      iconData = Icons.bluetooth;
      color = Colors.orange;
    } else {
      iconData = Icons.bluetooth_disabled;
      color = Colors.red;
    }
    return Icon(iconData, size: 30, color: color);
  }
}
