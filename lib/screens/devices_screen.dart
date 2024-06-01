import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mobile/services/logger_service.dart';
import 'package:mobile/widgets/ble_device_discovered_card.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final _logger = LoggerService.logger;
  late Timer _timer;
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  final flutterBlue = FlutterBluePlus();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _scanSubscription?.cancel();
    super.dispose();
  }

  void startScanning() {
    _logger.i('Starting BLE scan');
    FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 4),
        continuousUpdates: true,
        removeIfGone: const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
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
              ),
            ),
            Expanded(
              child: StreamBuilder<List<ScanResult>>(
                stream: FlutterBluePlus.scanResults,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return BleDeviceDiscoveredCard(
                          device: snapshot.data![index],
                        );
                      },
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(child: Text('No devices found'));
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: startScanning,
          child: const Icon(
            Icons.bluetooth_searching,
            color: Colors.green,
          ),
        ));
  }
}
