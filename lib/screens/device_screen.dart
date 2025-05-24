import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../utils/mobius_api.dart';
import 'gps_map_screen.dart';

class DeviceScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  BluetoothCharacteristic? targetCharacteristic;
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;
  bool isConnected = false;

  double temp = 0.0;
  int heartrate = 0;
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
    widget.device.connectionState.listen((state) {
      _connectionState = state;
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
        String raw = utf8.decode(value).trim(); // 💡 중요: 개행 제거
        print("✅ BLE 수신: $raw");
        _handleSensorData(raw);
      }
    });
  }

  void _handleSensorData(String raw) {
    List<String> parts = raw.split(',');

    for (String part in parts) {
      List<String> pair = part.split(':');
      if (pair.length != 2) continue;

      String type = pair[0].trim().toUpperCase();
      String valStr = pair[1].trim();

      setState(() {
        switch (type) {
          case 'TEMP':
            temp = double.tryParse(valStr) ?? 0.0;
            break;
          case 'HEARTRATE':
            heartrate = int.tryParse(valStr) ?? 0;
            break;
          case 'LAT':
            latitude = double.tryParse(valStr) ?? 0.0;
            break;
          case 'LNG':
            longitude = double.tryParse(valStr) ?? 0.0;
            break;
        }
      });

      sendToMobius(valStr, type.toLowerCase());
    }
  }

  Widget _buildSensorTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 18)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.device.platformName)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSensorTile("🌡 온도", "${temp.toStringAsFixed(1)} °C"),
            _buildSensorTile("❤️ 심박수", "$heartrate bpm"),
            _buildSensorTile("🌍 위도", latitude.toStringAsFixed(6)),
            _buildSensorTile("🧭 경도", longitude.toStringAsFixed(6)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GpsMapScreen(latitude: latitude, longitude: longitude),
                  ),
                );
              },
              child: Text("🗺 지도에서 위치 보기"),
            ),
          ],
        ),
      ),
    );
  }
}
