import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mobile/services/ble_service.dart';
import 'package:mobile/services/logger_service.dart';
import 'package:mobile/widgets/ble_device_discovered_card.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final _logger = LoggerService.logger;
  final _bleService = BleService();
  List<ScanResult> _bleDevices = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    bleScan();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      bleScan();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  Future<void> bleScan() async {
    // Retrieve the list of BLE devices and update the state
    var bleDevices = await _bleService.getBleDevices();
    if (bleDevices.isNotEmpty && mounted) {
      setState(() {
        _bleDevices = bleDevices;
      });
    }

    for (var device in bleDevices) {
      _logger.i("$device.device.rssi $device.advertisementData.advName");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'Discovered BLE devices',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )),
        _bleDevices.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: _bleDevices.length,
                  itemBuilder: (context, index) {
                    return BleDeviceDiscoveredCard(
                        device: _bleDevices[index], isNearby: true);
                  },
                ),
              )
            : const CircularProgressIndicator(),
      ],
    );
  }
}
