import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_expense/bloc/budget/budget_bloc.dart';
import 'package:smart_expense/bloc/budget/budget_event.dart';
import 'package:smart_expense/bloc/budget/budget_state.dart';
import 'package:smart_expense/bloc/expense/expense_bloc.dart';
import 'package:smart_expense/bloc/expense/expense_event.dart';
import 'package:smart_expense/bloc/expense/expense_state.dart';
import 'package:smart_expense/data/datasource/hive_service.dart';
import 'package:smart_expense/models/expense_model.dart';
import 'package:smart_expense/presentation/screens/add_expense_screen.dart';
import 'package:smart_expense/presentation/screens/analysis_chat_screen.dart';
import 'package:smart_expense/presentation/screens/expense_list_screen.dart';
import 'package:smart_expense/presentation/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ExpenseBloc>().add(LoadExpenses());
    context.read<BudgetBloc>().add(LoadMonthlyBudget());
  }

  double calculateTotal(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatter.format(amount);
  }

  List<GridItem> gridItems = [
    GridItem("Add Expense", Icons.add_circle, const AddExpenseScreen()),
    GridItem("Your Expenses", Icons.list_alt, const ExpenseListScreen()),
  ];

  Map<String, double> categoryTotals(List<Expense> expenses) {
    final Map<String, double> data = {};

    for (var expense in expenses) {
      if (data.containsKey(expense.category)) {
        data[expense.category] = data[expense.category]! + expense.amount;
      } else {
        data[expense.category] = expense.amount;
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Expense"), centerTitle: true),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExpenseError) {
            return Center(child: Text(state.message));
          }

          if (state is ExpenseLoaded) {
            final expenses = state.expenses;
            final total = calculateTotal(expenses);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        /// TOTAL SPENDING CARD
                        Expanded(
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              height: 160,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff4facfe),
                                    Color(0xff00f2fe),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total Spending",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    formatCurrency(total),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// PIE CHART CARD
                        Expanded(
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AnalysisChartScreen(expenses: expenses),
                                  ),
                                );
                              },
                              child: Container(
                                height: 160,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 199, 229, 255),
                                      Color.fromARGB(255, 183, 245, 249),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: buildPieChart(expenses),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BUDGET PROGRESS
                  BlocBuilder<BudgetBloc, BudgetState>(
                    builder: (context, state) {
                      double budget = 0;

                      if (state is BudgetLoaded) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Monthly Budget",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatCurrency(state.monthlyBudget),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      }
                      return SizedBox();
                    },
                  ),

                  const SizedBox(height: 10),

                  BlocBuilder<BudgetBloc, BudgetState>(
                    builder: (context, budgetState) {
                      double budgetLimit = 0;

                      if (budgetState is BudgetLoaded) {
                        budgetLimit = budgetState.monthlyBudget;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: budgetLimit == 0
                                ? 0
                                : (total / budgetLimit > 1
                                      ? 1
                                      : total / budgetLimit),
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "${formatCurrency(budgetLimit - total)} remaining",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 25),

                  const SizedBox(height: 25),

                  /// QUICK ACTIONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Quick Actions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.settings, size: 28),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: gridItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.4,
                        ),
                    itemBuilder: (context, index) {
                      final item = gridItems[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => item.screen),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item.icon,
                                size: 40,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  /// RECENT EXPENSES
                  const Text(
                    "Recent Expenses",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: expenses.length > 3 ? 3 : expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(expense.category),
                          subtitle: Text(
                            DateFormat(
                              "dd MMM yyyy, hh:mm a",
                            ).format(expense.dateTime.toLocal()),
                          ),
                          trailing: Text(
                            formatCurrency(expense.amount),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget buildPieChart(List<Expense> expenses) {
    final data = categoryTotals(expenses);

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
          sections: data.entries.map((entry) {
            final color = colors[index % colors.length];
            index++;

            return PieChartSectionData(
              color: color,
              value: entry.value,
              title: entry.key,
              radius: 50,
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

class GridItem {
  final String title;
  final IconData icon;
  final Widget screen;

  GridItem(this.title, this.icon, this.screen);
}
