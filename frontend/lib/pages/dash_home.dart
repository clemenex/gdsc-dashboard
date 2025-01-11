import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

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
        actions: [
          Padding(
              padding: EdgeInsets.all(4),
              child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  icon: Icon(Icons.logout, color: Colors.white)))
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Lottie.asset('assets/avatar1.json'),
                    Text('Hi Joe!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Ready to learn more about the Philippines?'),
                  ],
                )),
            Expanded(
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
                                    borderData: FlBorderData(
                                        show: false), // Hide the border
                                    gridData: FlGridData(
                                        show: false), // Show grid lines
                                    titlesData: FlTitlesData(
                                      // Show only X axis labels and hide Y axis labels
                                      leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                              showTitles:
                                                  false)), // Hide Y axis labels
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
                                          showTitles:
                                              true, // Show X axis labels
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
                                  onPressed: () async {
                                    final interpretation = await interpretGraph(
                                      '2024 National Budget of the Philippines',
                                      [8, 6, 10, 4],
                                      ['A', 'B', 'C', 'D'],
                                    );

                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            buildSheet(interpretation),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(10))));
                                  },
                                  child: Text('interpret'),
                                ),
                              )
                            ]),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSheet(String interpretation) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title for the interpretation
          Text(
            'Graph Interpretation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),

          // Displaying the interpretation
          Text(
            interpretation,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> interpretGraph(
    String title, List<double> data, List<String> labels) async {
  String result = '';

  try {
    await for (var value in Gemini.instance.promptStream(parts: [
      Part.text('Interpret the following data visualization:\n'),
      Part.text('Title: $title\n'),
      Part.text('Data points: ${data.join(", ")}\n'),
      Part.text('Labels: ${labels.join(", ")}\n'),
    ])) {
      if (value != null && value.output != null) {
        result += value.output!;
      }
    }
  } catch (e) {
    print('Error during interpretation: $e');
    result = 'Failed to interpret the graph.';
  }

  return result;
}
