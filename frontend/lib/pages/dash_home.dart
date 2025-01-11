import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashHomePage extends StatelessWidget {
  const DashHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> yValues = [3, 5, 8, 6]; // Y-axis values
    final List<String> xLabels = ['A', 'B', 'C', 'D']; // X-axis labels
    String graphTitle = '2024 National Budget of the Philippines';

    List<BarChartGroupData> _buildBarGroups() {
      return List.generate(
        yValues.length,
        (index) => BarChartGroupData(
          x: index, // X index
          barRods: [
            BarChartRodData(
              toY: yValues[index], // Y value
              color: Colors.blue, // Bar color
              borderRadius: BorderRadius.circular(4), // Rounded edges
            ),
          ],
        ),
      );
    }

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
              icon: Icon(Icons.logout, color: Colors.white),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, double>>(
        future: fetchBudgetData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Firestore data successfully fetched
          final budgetData = snapshot.data!;
          final labels = budgetData.keys.toList(); // X-axis labels (years)
          final values = budgetData.values.toList(); // Y-axis values (amounts)

          return Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Lottie.asset('assets/avatar1.json'),
                      Text(
                        'Hi Joe!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text('Ready to learn more about the Philippines?'),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 && index < labels.length) {
                                  return Text(labels[index]); // Display years
                                }
                                return Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toStringAsFixed(0)); // Amounts
                              },
                            ),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              values.length,
                              (index) =>
                                  FlSpot(index.toDouble(), values[index]),
                            ),
                            isCurved: true,
                            barWidth: 4,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

 Future<Map<String, double>> fetchBudgetData() async {
  try {
    // Fetch data from Firestore
    final snapshot =
        await FirebaseFirestore.instance.collection('budget').get();

    // Initialize map for parsed data
    final data = <String, double>{};

    for (var doc in snapshot.docs) {
      // Extract fields
      final year = doc['YEAR'] as String?; // YEAR field
      final amount = doc['TOTAL BUDGET'] as String?; // TOTAL BUDGET field

      // Ensure both fields are non-null
      if (year == null || amount == null) {
        print('Skipping document with missing fields: ${doc.data()}');
        continue;
      }

      // Parse year and sanitize the amount
      final parsedYear = int.tryParse(year);
      final sanitizedAmount = amount.replaceAll(',', ''); // Remove commas
      final parsedAmount = double.tryParse(sanitizedAmount);

      if (parsedYear != null && parsedAmount != null) {
        data[year] = parsedAmount; // Add valid entries to the map
      } else {
        print('Skipping invalid document: ${doc.data()}');
      }
    }

    if (data.isEmpty) {
      print('No valid data found in the collection.');
    } else {
      print('Fetched budget data: $data');
    }

    return data;
  } catch (e) {
    print('Detailed error: $e'); // Log any error
    throw Exception('Failed to fetch budget data.');
  }
}
}
