import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense/bloc/expense/expense_bloc.dart';
import 'package:smart_expense/bloc/expense/expense_event.dart';
import 'package:smart_expense/bloc/expense/expense_state.dart';
import 'package:smart_expense/presentation/screens/edit_expense_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  String? selectedCategory;
  double minAmount = 1;
  double maxAmount = 20000;

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpenses());
  }

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expenses'), centerTitle: true),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        context.read<ExpenseBloc>().add(
                          QuerySearchEvent(value),
                        );
                      },
                      decoration: InputDecoration(
                        hint: Text("Search"),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Icon(Icons.search),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  if (state is ExpenseLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ExpenseLoaded) {
                    final expenses = state.expenses;
                    if (expenses.isEmpty) {
                      return Center(child: Text('No expenses yet.'));
                    }
                    return ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(
                              '₹ ${expense.amount} - ${expense.description}',
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              DateFormat(
                                'dd MMM yyyy, hh:mm a',
                              ).format(expense.dateTime.toLocal()),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black),
                                  onPressed: () {
                                    //edit expense
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditExpenseScreen(expense: expense),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red.shade400,
                                  ),
                                  onPressed: () {
                                    //delete expense
                                    context.read<ExpenseBloc>().add(
                                      DeleteExpense(expense.id),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ExpenseError) {
                    return Center(child: Text(state.message));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                openFilterBottomSheet(context);
              },
              label: Text("Filter"),
              icon: Icon(Icons.filter_list, color: Colors.blue, size: 20),
            ),
            SizedBox(width: 4),
            TextButton.icon(
              onPressed: () {
                openSortBottomSheet(context);
              },
              label: Text("Sort"),
              icon: Icon(Icons.sort, color: Colors.blue, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  //Filter bottomsheet
  void openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Drag Handle
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  /// Title
                  const Text(
                    "Filter Expenses",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 24),

                  /// Category Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: InputDecoration(
                      labelText: "Category",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Food", child: Text("Food")),
                      DropdownMenuItem(
                        value: "Transport",
                        child: Text("Transport"),
                      ),
                      DropdownMenuItem(
                        value: "Entertainment",
                        child: Text("Entertainment"),
                      ),
                      DropdownMenuItem(
                        value: "Shopping",
                        child: Text("Shopping"),
                      ),
                      DropdownMenuItem(value: "Bills", child: Text("Bills")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (value) {
                      selectedCategory = value;
                    },
                  ),

                  const SizedBox(height: 24),

                  /// Amount Range Label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Amount Range",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "₹${minAmount.toInt()} - ₹${maxAmount.toInt()}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 81, 61, 170),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// Range Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      overlayShape: SliderComponentShape.noOverlay,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 0,
                      ),
                    ),
                    child: RangeSlider(
                      min: 1,
                      max: 20000,
                      divisions: 200,
                      labels: RangeLabels(
                        minAmount.toStringAsFixed(0),
                        maxAmount.toStringAsFixed(0),
                      ),
                      values: RangeValues(minAmount, maxAmount),
                      onChanged: (RangeValues values) {
                        setState(() {
                          minAmount = values.start;
                          maxAmount = values.end;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedCategory = null;
                                minAmount = 1;
                                maxAmount = 20000;
                              });
                              context.read<ExpenseBloc>().add(LoadExpenses());
                              Navigator.pop(context);
                            },
                            child: const Text("Clear"),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              context.read<ExpenseBloc>().add(
                                FilterExpensesEvent(
                                  category: selectedCategory,
                                  minAmount: minAmount,
                                  maxAmount: maxAmount,
                                ),
                              );

                              Navigator.pop(context);
                            },
                            child: const Text("Apply"),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //Sorting bottomsheet
  void openSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                /// drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text(
                  "Sort Expenses",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 20),

                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text("Date (Newest First)"),
                  onTap: () {
                    context.read<ExpenseBloc>().add(SortExpensesByDateDesc());
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.calendar_today_outlined),
                  title: Text("Date (Oldest First)"),
                  onTap: () {
                    context.read<ExpenseBloc>().add(SortExpensesByDateAsc());
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.currency_rupee),
                  title: Text("Amount (High → Low)"),
                  onTap: () {
                    context.read<ExpenseBloc>().add(SortExpensesByAmountDesc());
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.currency_rupee_outlined),
                  title: Text("Amount (Low → High)"),
                  onTap: () {
                    context.read<ExpenseBloc>().add(SortExpensesByAmountAsc());
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
