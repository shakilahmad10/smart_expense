import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_expense/models/expense_model.dart';

class CustomPieChart extends StatelessWidget {
  final List<Expense> expenses;

  const CustomPieChart({super.key, required this.expenses});

  Map<String, double> categoryTotals() {
    final Map<String, double> data = {};

    for (var expense in expenses) {
      data[expense.category] = (data[expense.category] ?? 0) + expense.amount;
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final data = categoryTotals();

    if (data.isEmpty) {
      return const Center(child: Text("No data"));
    }

    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.teal,
    ];

    int index = 0;

    return SizedBox(
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: data.entries.map((entry) {
            final color = colors[index % colors.length];
            index++;

            return PieChartSectionData(
              color: color,
              value: entry.value,
              title: entry.key,
              radius: 90,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
