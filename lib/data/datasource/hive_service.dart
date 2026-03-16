import 'package:hive/hive.dart';
import 'package:smart_expense/models/expense_model.dart';

class HiveService {
  final Box<Expense> _expenseBox = Hive.box<Expense>('expenses');

  //Add Expense
  Future<void> addExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  //Get all expenses
  List<Expense> getAllExpenses() {
    return _expenseBox.values.toList();
  }

  //Delete Expense
  // Future<void> deleteExpense(String id) async {
  //   await _expenseBox.delete(id);
  // }

  Future<void> deleteExpense(String id) async {
    final box = Hive.box<Expense>('expenses');

    // Find the Hive key for this expense
    final key = box.keys.firstWhere(
      (k) => box.get(k)!.id == id,
      orElse: () => null,
    );

    if (key != null) {
      await box.delete(key);
    } else {
      print('Expense with id $id not found in Hive!');
    }
  }

  //Update Expense
  Future<void> updateExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }
}
