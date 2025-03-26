import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trackactive/models/habit.dart'; // Import your habit model
import 'package:trackactive/services/habit_service.dart'; // Import the service to fetch habits

class HabitVisualizationScreen extends StatefulWidget {
  final int userId;

  const HabitVisualizationScreen({super.key, required this.userId});

  @override
  HabitVisualizationScreenState createState() =>
      HabitVisualizationScreenState();
}

class HabitVisualizationScreenState extends State<HabitVisualizationScreen> {
  List<HabitModel> _habits = []; // Initialize with an empty list
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  // Load habits data for the given user
  Future<void> _loadHabits() async {
    // final habits = await HabitService()
    //     .getHabitsByUserId(widget.userId); // Get habits from your service
    setState(() {
      //   _habits = habits;
      isLoading = false;
    });
  }

  // Generate habit progress data based on the habits (for example, by using some condition)
  List<FlSpot> _generateHabitProgressData() {
    return _habits
        .asMap()
        .entries
        .map((entry) => FlSpot(
            entry.key.toDouble(), entry.value.notificationsEnabled.toDouble()))
        .toList();
  }

  // Generate colors for the bars based on habit status (for example, enabled vs disabled)
  Color _getColorForHabit(int index) {
    final habit = _habits[index];
    if (habit.notificationsEnabled == 1) {
      return Colors.green; // Completed habit
    } else {
      return Colors.red; // Incomplete habit
    }
  }

  // Generate Pie chart data
  List<PieChartSectionData> _generatePieChartSections() {
    int completed =
        _habits.where((habit) => habit.notificationsEnabled == 1).length;
    int incomplete = _habits.length - completed;

    return [
      PieChartSectionData(
        color: Colors.green,
        value: completed.toDouble(),
        title: 'Completed\n$completed',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.red,
        value: incomplete.toDouble(),
        title: 'Incomplete\n$incomplete',
        radius: 50,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habit Progress')),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Pie Chart for habit completion status
                    const Text(
                      'Habit Completion Status',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          sections: _generatePieChartSections(),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Line Chart for habit progress with multiple colors
                    const Text(
                      'Habit Progress Over Time',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    AspectRatio(
                      aspectRatio: 1.7,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: 100,
                          lineBarsData: [
                            LineChartBarData(
                              spots: _generateHabitProgressData(),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 2,
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                          titlesData: const FlTitlesData(show: true),
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: 10, // Add horizontal grid lines
                            verticalInterval: 1, // Add vertical grid lines
                            getDrawingHorizontalLine: (value) {
                              return const FlLine(
                                color:
                                    Colors.grey, // Color for horizontal lines
                                strokeWidth: 0.5,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return const FlLine(
                                color: Colors.grey, // Color for vertical lines
                                strokeWidth: 0.5,
                              );
                            },
                          ),
                          borderData: FlBorderData(show: true),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bar Chart for habit completion frequency with multiple colors
                    const Text(
                      'Habit Completion Frequency',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    AspectRatio(
                      aspectRatio: 1.7,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 100,
                          barGroups: _habits
                              .asMap()
                              .entries
                              .map((entry) => BarChartGroupData(
                                    x: entry.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: entry.value.notificationsEnabled
                                                .toDouble() *
                                            100, // Corrected 'y' to 'toY'
                                        color: _getColorForHabit(entry
                                            .key), // Set color based on habit status
                                        width: 16,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ],
                                  ))
                              .toList(),
                          titlesData: const FlTitlesData(show: true),
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: 10, // Add horizontal grid lines
                            verticalInterval: 1, // Add vertical grid lines
                            getDrawingHorizontalLine: (value) {
                              return const FlLine(
                                color:
                                    Colors.grey, // Color for horizontal lines
                                strokeWidth: 0.5,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return const FlLine(
                                color: Colors.grey, // Color for vertical lines
                                strokeWidth: 0.5,
                              );
                            },
                          ),
                          borderData: FlBorderData(show: true),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
