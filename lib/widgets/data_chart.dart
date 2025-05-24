import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DataChart extends StatelessWidget {
  final List<double> data;

  const DataChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map(
                    (entry) => FlSpot(entry.key.toDouble(), entry.value),
              ).toList(),
              isCurved: true,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
