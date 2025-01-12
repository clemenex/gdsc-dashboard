import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DashHomePage extends StatefulWidget {
  const DashHomePage({super.key});

  @override
  State<DashHomePage> createState() => _DashHomePageState();
}

class _DashHomePageState extends State<DashHomePage> {
  @override
  Widget build(BuildContext context) {
    PageController _controller = PageController();
    String graphTitle = 'Yearly National Budget of the Philippines';

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
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Lottie.asset('assets/avatar1.json'),
                  Text(
                    'Hi Joe!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('Ready to learn more about the Philippines?'),
                ],
              ),
            ),
            FutureBuilder<Map<String, double>>(
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
                final labels =
                    budgetData.keys.toList(); // X-axis labels (years)
                final values =
                    budgetData.values.toList(); // Y-axis values (amounts)

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        color: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                // bottomTitles: AxisTitles(
                                //   sideTitles: SideTitles(
                                //     showTitles: true,
                                //     getTitlesWidget: (value, meta) {
                                //       final index = value.toInt();
                                //       if (index >= 0 && index < labels.length) {
                                //         return Text(
                                //             labels[index]); // Display years
                                //       }
                                //       return Text('');
                                //     },
                                //   ),
                                // ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: false), // Y-axis titles
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: false), // Disable top labels
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: false), // Disable top labels
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles:
                                          false), // Disable right labels
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
                        Padding(
                          padding: EdgeInsets.only(top: 24, bottom: 8),
                          child: Text(graphTitle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final interpretation = await interpretGraph(
                              '2024 National Budget of the Philippines',
                              [8, 6, 10, 4],
                              ['A', 'B', 'C', 'D'],
                            );
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                      padding: EdgeInsets.all(16.0),
                                      child: PageView.builder(
                                        controller: _controller,
                                        itemCount: 3,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                interpretation[index],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),

                                              SizedBox(height: 16),

                                              Container(
                                                  alignment: Alignment(0, 0.75),
                                                  child: SmoothPageIndicator(
                                                    controller: _controller,
                                                    count: 3,
                                                    effect: WormEffect(
                                                      dotWidth: 10,
                                                      dotHeight: 10,
                                                      spacing: 8,
                                                      radius: 10,
                                                      dotColor: Colors.grey,
                                                      activeDotColor:
                                                          Colors.blue,
                                                    ),
                                                  )),
                                            ],
                                          );
                                        },
                                      ),
                                    ));
                          },
                          child: Text('Interpret'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
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

  List<String> splitIntoParagraphs(String text) {
    List<String> lines = text.split('\n');
    List<String> paragraphs = [];
    String currentParagraph = "";

    for (String line in lines) {
      if (line.trim().isNotEmpty) {
        currentParagraph += line.trim() + " ";
      } else if (currentParagraph.isNotEmpty) {
        paragraphs.add(currentParagraph.trim());
        currentParagraph = "";
      }
    }
    // Add the last paragraph if it exists
    if (currentParagraph.isNotEmpty) {
      paragraphs.add(currentParagraph.trim());
    }
    return paragraphs;
  }

  Future<List<String>> interpretGraph(
      String title, List<double> data, List<String> labels) async {
    String result = '';

    try {
      await for (var value in Gemini.instance.promptStream(parts: [
        Part.text(
            'Given the following context, can you create me a data storytelling like interpretation of our graphs? I want you to give me 3 paragraphs with 3 sentences each that captures the heart of the user as well as address their problems. The following is the information about the graph: \n'),
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

    List<String> paragraphs = splitIntoParagraphs(result);

    return paragraphs;
  }
}
