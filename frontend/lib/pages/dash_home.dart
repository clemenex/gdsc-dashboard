import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashHomePage extends StatelessWidget {
  const DashHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 75,
        backgroundColor: Colors.red.shade300,
        title: Text('DashGov',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 200,
                        //child: Container(color: Colors.red),
                        child: BarChart(
                          BarChartData(
                            borderData:
                                FlBorderData(show: false), // Hide the border
                            gridData:
                                FlGridData(show: false), // Show grid lines
                            titlesData: FlTitlesData(
                              // Show only X axis labels and hide Y axis labels
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: false)), // Hide Y axis labels
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles:
                                          false)), // Hide right axis labels
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles:
                                          false)), // Hide top axis labels Hide Y axis labels
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true, // Show X axis labels
                                  getTitlesWidget: (value, meta) {
                                    // Customize X axis labels
                                    if (value == 0) {
                                      return Text('A');
                                    } else if (value == 1) {
                                      return Text('B');
                                    } else if (value == 2) {
                                      return Text('C');
                                    } else if (value == 3) {
                                      return Text('D');
                                    }
                                    return Text('');
                                  },
                                ),
                              ),
                            ), // Show titles on axes
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: 8, // Bar height
                                    color: Colors.blue, // Bar color
                                    width: 16, // Bar width
                                    // borderRadius: BorderRadius.horizontal(
                                    //   left: Radius.circular(0),
                                    //   right: Radius.circular(0),
                                    // ),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: 6,
                                    color: Colors.blue,
                                    width: 16,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [
                                  BarChartRodData(
                                    toY: 10,
                                    color: Colors.blue,
                                    width: 16,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 3,
                                barRods: [
                                  BarChartRodData(
                                    toY: 4,
                                    color: Colors.blue,
                                    width: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '2024 National Budget of the Philippines',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                          child: ElevatedButton(
                              onPressed: () {}, child: Text('Interpret')))
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}
