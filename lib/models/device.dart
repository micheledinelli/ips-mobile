class Device {
  int deviceId;
  String name;

  Device({required this.deviceId, required this.name});

  factory Device.fromJson(Map<String, dynamic> map) {
    return Device(
      deviceId: map['deviceId'],
      name: map['name'],
    );
  }
}
