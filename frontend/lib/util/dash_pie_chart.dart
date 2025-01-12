import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashPie extends StatelessWidget {
  const DashPie({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
                value: 37.9,
                color: const Color.fromARGB(255, 79, 163, 53),
                title: "Social Services"),
            PieChartSectionData(
                value: 29.6, color: Colors.blue, title: "Economic Services"),
            PieChartSectionData(
                value: 15.5,
                color: const Color.fromARGB(255, 243, 33, 33),
                title: "General Public Services"),
            PieChartSectionData(
                value: 12.1,
                color: const Color.fromARGB(255, 243, 198, 33),
                title: "Debt Burden"),
            PieChartSectionData(
                value: 4.9,
                color: const Color.fromARGB(255, 255, 255, 255),
                title: "Defense"),
          ],
        ),
      ),
    );
    ;
  }
}
