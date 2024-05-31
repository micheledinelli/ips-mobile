import 'package:flutter/material.dart';
import 'package:mobile/models/position.dart';

class PositionCard extends StatelessWidget {
  final Position position;

  const PositionCard({required this.position, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              position.room != null
                  ? 'Room: ${position.room}'
                  : 'Room: Unknown',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
