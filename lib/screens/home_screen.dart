import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/models/access_point.dart';
import 'package:mobile/models/device.dart';
import 'package:mobile/models/position.dart';
import 'package:mobile/services/ble_service.dart';
import 'package:mobile/services/logger_service.dart';
import 'package:mobile/services/notification_service.dart';
import 'package:mobile/services/wifi_service.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/widgets/device_card.dart';
import 'package:mobile/widgets/position_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _logger = LoggerService.logger;
  final _wifiService = WifiService();
  final _bleService = BleService();
  final _notificationService = NotificationService();

  Position? _position;
  List<AccessPoint> _accessPoints = [];
  List<Device> _bleDevices = [];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    wifiAndBleScan();

    // Fetch the position every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      wifiAndBleScan();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  Future<void> wifiAndBleScan() async {
    // Retrieve the list of access points and update the state
    var accessPoints = await _wifiService.getAccessPoints();
    if (accessPoints.isNotEmpty && mounted) {
      setState(() {
        _accessPoints = accessPoints;
      });
    }

    var bleDevices = await _bleService.getBleDevices();
    if (bleDevices.isNotEmpty && mounted) {
      setState(() {
        _bleDevices = bleDevices;
      });
    }

    // Fetch the position based on the access points
    fetchPosition(accessPoints: accessPoints, bleDevices: bleDevices);
  }

  Future<void> fetchPosition(
      {List<AccessPoint>? accessPoints, List<Device>? bleDevices}) async {
    if (accessPoints == null || accessPoints.isEmpty) {
      _logger.w("No access points available to fetch position");
      return;
    }

    try {
      var backendUrl = dotenv.env['BACKEND_URL'];

      // Convert the list of access points to a list of maps
      List<Map<String, dynamic>> accessPointsMap =
          _accessPoints.map((ap) => ap.toMap()).toList();

      // Convert the list of devices to a list of maps
      List<Map<String, dynamic>> bleDevicesMap =
          _bleDevices.map((d) => d.toMap()).toList();

      final response = await http.post(
        Uri.parse('$backendUrl/position'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': dotenv.env['ID'],
          'accessPoints': accessPointsMap,
          'bleDevices': bleDevicesMap
        }),
      );

      if (response.statusCode == 200) {
        dynamic responseData = json.decode(response.body);
        if (mounted) {
          setState(() {
            _position = Position.fromJson(responseData);
          });

          bool granted = _position!.granted!;
          if (!granted) {
            _notificationService.showNotification(
              title: 'Access Denied',
              body: _position!.violation!,
              type: NotificationType.values.firstWhere((e) =>
                  e.toString() ==
                  'NotificationType.${_position!.notificationType}'),
            );
          }
        }
      } else {
        _logger.e('Failed to load position');
      }
    } catch (e) {
      _logger.e('Error fetching position: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              _position != null
                  ? 'Detected position'
                  : 'Detecting current position',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )),
        Align(
          alignment: Alignment.center,
          child: _position != null
              ? PositionCard(position: _position!)
              : const CircularProgressIndicator(),
        ),
        _position != null
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    _position!.hasRequiredDevices()
                        ? 'Devices required'
                        : 'No devices required',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ))
            : Container(),
        _position != null && _position!.hasRequiredDevices()
            ? Expanded(
                child: ListView.builder(
                  itemCount: _position!.devicesRequired!.length,
                  itemBuilder: (context, index) {
                    return DeviceCard(
                        device: _position!.devicesRequired![index],
                        isNearby: _bleDevices.any((d) =>
                            (d.deviceId ==
                                _position!.devicesRequired![index].deviceId) ||
                            d.name == _position!.devicesRequired![index].name));
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}
