import 'package:flutter/material.dart';

class ConnectionDialog extends StatelessWidget {
  const ConnectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("No WiFi Connection",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
      content: const Text("Please ensure WiFi is enabled.",
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
