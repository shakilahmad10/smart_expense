import 'package:hive/hive.dart';
import 'package:smart_expense/models/expense_model.dart';

class HiveService {
  final Box<Expense> _expenseBox = Hive.box<Expense>('expenses');
  final Box<dynamic> _settingsBox = Hive.box('settings');

  //Add Expense
  Future<void> addExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  //Get all expenses
  List<Expense> getAllExpenses() {
    return _expenseBox.values.toList();
  }

  // Delete Expense
  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
  }

  //Update Expense
  Future<void> updateExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  ///----------------------
  ///Settings methods
  ///----------------------

  ///Save Monthly Budget
  Future<void> saveMonthlyBudget(double amount) async {
    await _settingsBox.put('monthly_budget', amount);

    final now = DateTime.now();
    await _settingsBox.put('budget_month', now.month);
    await _settingsBox.put('budget_year', now.year);
  }

  bool isNewMonth() {
    final now = DateTime.now();

    final savedMonth = _settingsBox.get('budget_month');
    final savedYear = _settingsBox.get('budget_year');

    if (savedMonth == null || savedYear == null) {
      return false;
    }

    return now.month != savedMonth || now.year != savedYear;
  }

  void resetBudgetMonth() {
    final now = DateTime.now();

    _settingsBox.put('budget_month', now.month);
    _settingsBox.put('budget_year', now.year);
  }

  ///Get Monthly Budget
  double getMonthlyBudget() {
    return _settingsBox.get('monthly_budget', defaultValue: 0.0);
  }

  ///Clear All Expenses
  Future<void> clearAllExpenses() async {
    await _expenseBox.clear();
  }
}
