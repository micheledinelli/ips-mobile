import 'package:flutter/material.dart';

class BleDialog extends StatelessWidget {
  const BleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Bluetooth is not enabled",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
      content: const Text("Please ensure Bluetooth is on.",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK", style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}
