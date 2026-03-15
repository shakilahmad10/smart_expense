import 'package:smart_expense/data/datasource/hive_service.dart';
import 'package:smart_expense/models/expense_model.dart';

class ExpenseRepository {
  final HiveService _hiveService;

  ExpenseRepository(this._hiveService);

  //Add Expense
  Future<void> addExpense(Expense expense) async {
    await _hiveService.addExpense(expense);
  }

  //Get all expenses
  List<Expense> getAllExpenses() {
    return _hiveService.getAllExpenses();
  }

  //Delete Expense
  Future<void> deleteExpense(String id) async {
    await _hiveService.deleteExpense(id);
  }

  //Update Expense
  Future<void> updateExpense(Expense expense) async {
    await _hiveService.updateExpense(expense);
  }
}
