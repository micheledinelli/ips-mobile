import 'package:flutter/material.dart';
import 'package:mobile/models/device.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final bool isNearby;

  const DeviceCard({required this.device, required this.isNearby, super.key});

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
              leading: _buildIcon(isNearby),
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

  Widget _buildIcon(bool isNearby) {
    IconData iconData;
    Color color;
    if (isNearby) {
      iconData = Icons.bluetooth;
      color = Colors.green;
    } else {
      iconData = Icons.bluetooth_disabled;
      color = Colors.red;
    }
    return Icon(iconData, size: 30, color: color);
  }
}
