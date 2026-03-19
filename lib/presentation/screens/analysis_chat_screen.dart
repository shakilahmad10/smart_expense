import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense/models/expense_model.dart';
import 'package:smart_expense/presentation/widgets/custom_pie_chart.dart';

class AnalysisChartScreen extends StatefulWidget {
  final List<Expense> expenses;

  const AnalysisChartScreen({super.key, required this.expenses});

  @override
  State<AnalysisChartScreen> createState() => _AnalysisChartScreenState();
}

class _AnalysisChartScreenState extends State<AnalysisChartScreen> {
  double calculateTotal(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  Map<String, double> categoryTotals(List<Expense> expenses) {
    final Map<String, double> data = {};

    for (var expense in expenses) {
      data[expense.category] = (data[expense.category] ?? 0) + expense.amount;
    }

    return data;
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final total = calculateTotal(widget.expenses);
    final categories = categoryTotals(widget.expenses);

    return Scaffold(
      appBar: AppBar(title: const Text("Expense Analysis"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// TOTAL SUMMARY CARD
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff4facfe), Color(0xff00f2fe)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Total Spending",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formatCurrency(total),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// PIE CHART CARD
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Spending by Category",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 250,
                      child: CustomPieChart(expenses: widget.expenses),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// CATEGORY BREAKDOWN
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories.keys.elementAt(index);
                  final amount = categories.values.elementAt(index);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(Icons.pie_chart, color: Colors.blue),
                    ),
                    title: Text(category),
                    trailing: Text(
                      formatCurrency(amount),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
