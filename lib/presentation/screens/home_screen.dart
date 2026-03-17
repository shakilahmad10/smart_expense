import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_expense/bloc/expense/expense_bloc.dart';
import 'package:smart_expense/bloc/expense/expense_event.dart';
import 'package:smart_expense/bloc/expense/expense_state.dart';
import 'package:smart_expense/models/expense_model.dart';
import 'package:smart_expense/presentation/screens/add_expense_screen.dart';
import 'package:smart_expense/presentation/screens/expense_list_screen.dart';
import 'package:smart_expense/presentation/widgets/custom_grid_item.dart';

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
  }

  double calculateTotal(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  List<GridItem> gridItems = [
    GridItem("Add Expense", AddExpenseScreen()),
    GridItem("Your Expenses", ExpenseListScreen()),
  ];

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

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  // Total Expenses Card
                  Card(
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Expenses",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹$total",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Placeholder for chart or quick stats
                  Container(
                    height: 180,
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 22, 143, 183),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Chart / Analytics Here",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 250,
                    child: GridView.builder(
                      itemCount: 2,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // number of columns
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1.2,
                          ),
                      itemBuilder: (context, index) {
                        final item = gridItems[index];
                        return CustomGridItem(
                          title: item.title,
                          onTap: () {
                            // TO OPEN PAGE AS A BOTTOMSHEET
                            // showModalBottomSheet(
                            //   context: context,
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.vertical(
                            //       top: Radius.circular(20),
                            //     ),
                            //   ),
                            //   builder: (context) {
                            //     return AddExpenseScreen();
                            //   },
                            // );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => item.screen,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class GridItem {
  final String title;
  final Widget screen;

  GridItem(this.title, this.screen);
}
