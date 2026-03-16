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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expenses'), centerTitle: true),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ExpenseLoaded) {
            final expenses = state.expenses;
            if (expenses.isEmpty) {
              return Center(child: Text('No expenses yet.'));
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return Card(
                    color: const Color.fromARGB(255, 6, 185, 221),
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
              ),
            );
          } else if (state is ExpenseError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
