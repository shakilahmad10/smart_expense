import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                      decoration: InputDecoration(
                        hint: Text("Search"),
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
                            subtitle: Text('${expense.dateTime.toLocal()}'),
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
        TextEditingController minAmountController = TextEditingController();
        TextEditingController maxAmountController = TextEditingController();

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Title
                Text(
                  "Filter Expenses",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 20),

                /// Category Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: [
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
                  onChanged: (value) {},
                ),

                SizedBox(height: 16),

                /// Min Amount
                TextField(
                  controller: minAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Min Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                /// Max Amount
                TextField(
                  controller: maxAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Max Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Spacer(),

                /// Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Clear"),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () {
                              // Apply filter logic here
                              Navigator.pop(context);
                            },
                            child: Text("Apply"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                    // context.read<ExpenseBloc>().add(SortExpensesByDateDesc());
                    // Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.calendar_today_outlined),
                  title: Text("Date (Oldest First)"),
                  onTap: () {
                    // context.read<ExpenseBloc>().add(SortExpensesByDateAsc());
                    // Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.currency_rupee),
                  title: Text("Amount (High → Low)"),
                  onTap: () {
                    // context.read<ExpenseBloc>().add(SortExpensesByAmountDesc());
                    // Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.currency_rupee_outlined),
                  title: Text("Amount (Low → High)"),
                  onTap: () {
                    // context.read<ExpenseBloc>().add(SortExpensesByAmountAsc());
                    // Navigator.pop(context);
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
