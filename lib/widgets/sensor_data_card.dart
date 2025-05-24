import 'package:flutter/material.dart';

class SensorDataCard extends StatelessWidget {
  final String value;
  final DateTime timestamp;

  const SensorDataCard({
    Key? key,
    required this.value,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(Icons.analytics, color: Colors.blueAccent),
        title: Text("측정값: $value", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("시간: ${timestamp.toLocal().toIso8601String().substring(11, 19)}"),
      ),
    );
  }
}
