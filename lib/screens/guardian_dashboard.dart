import 'package:flutter/material.dart';

class GuardianDashboardScreen extends StatelessWidget {
  const GuardianDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('보호자 대시보드'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSensorCard("🌡 온도", "23.5 °C"),
            _buildSensorCard("❤️ 심박수", "78 bpm"),
            const SizedBox(height: 24),
            const Text(
              "최근 위치",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(
                child: Text("🗺 지도가 여기에 표시됩니다"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
