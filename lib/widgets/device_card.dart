import 'package:flutter/material.dart';
import 'package:mobile/models/device.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final int rssi;

  const DeviceCard({required this.device, required this.rssi, super.key});

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
              leading: _buildIcon(rssi),
              title: Text(
                device.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                'ID: ${device.deviceId}',
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
    } else if (rssi > -90) {
      iconData = Icons.bluetooth;
      color = Colors.orange;
    } else {
      iconData = Icons.bluetooth;
      color = Colors.red;
    }
    return Icon(iconData, size: 30, color: color);
  }
}
