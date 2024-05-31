import 'package:mobile/models/device.dart';

class Position {
  String? room;
  bool? granted;
  String? notificationType;
  List<Device>? devicesRequired;
  String? violation;

  Position(
      {required this.room,
      required this.granted,
      required this.notificationType,
      required this.devicesRequired,
      required this.violation});

  factory Position.fromJson(Map<String, dynamic> map) {
    return Position(
      room: map['room'],
      granted: map['granted'],
      notificationType: map['notificationType'],
      devicesRequired: List<Device>.from(
          map['devicesRequired'].map((x) => Device.fromJson(x))),
      violation: map['violation'],
    );
  }

  bool hasRequiredDevices() {
    return devicesRequired!.isNotEmpty;
  }
}
