import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../utils/mobius_api.dart';

class SensorDashboardScreen extends StatefulWidget {
  final BluetoothDevice device;

  const SensorDashboardScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<SensorDashboardScreen> createState() => _SensorDashboardScreenState();
}

class _SensorDashboardScreenState extends State<SensorDashboardScreen> {
  BluetoothCharacteristic? targetCharacteristic;
  double temp = 0.0;
  double humid = 0.0;
  double co2 = 0.0;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    widget.device.connectionState.listen((state) {
      isConnected = state == BluetoothConnectionState.connected;
      if (isConnected) _discoverServices();
      setState(() {});
    });
  }

  Future<void> _discoverServices() async {
    final services = await widget.device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          targetCharacteristic = characteristic;
          _subscribeToCharacteristic(characteristic);
          break;
        }
      }
    }
  }

  void _subscribeToCharacteristic(BluetoothCharacteristic characteristic) {
    characteristic.setNotifyValue(true);
    characteristic.value.listen((value) {
      if (value.isNotEmpty) {
        String received = utf8.decode(value);
        _handleSensorData(received);
      }
    });
  }

  void _handleSensorData(String raw) {
    List<String> parts = raw.split(":");
    if (parts.length != 2) return;

    String type = parts[0].trim().toUpperCase();
    String valStr = parts[1].trim();
    double? val = double.tryParse(valStr);
    if (val == null) return;

    setState(() {
      switch (type) {
        case 'TEMP':
          temp = val;
          break;
        case 'HUMID':
          humid = val;
          break;
        case 'CO2':
          co2 = val;
          break;
        default:
          return;
      }
    });

    // Mobius 서버 전송
    String container = type.toLowerCase();
    sendToMobius(valStr, container);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("실시간 센서 대시보드")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTile("🌡 온도", temp, "°C"),
            const SizedBox(height: 16),
            _buildTile("💧 습도", humid, "%"),
            const SizedBox(height: 16),
            _buildTile("🌫 CO₂", co2, "ppm"),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String label, double value, String unit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(
            "${value.toStringAsFixed(1)} $unit",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}