import 'package:smart_expense/data/datasource/hive_service.dart';

class BudgetRepository {
  final HiveService _hiveService;

  const BudgetRepository(this._hiveService);

  Future<void> saveMonthlyBudget(double amount) async {
    await _hiveService.saveMonthlyBudget(amount);
  }

  double getMonthlyBudget() {
    if (_hiveService.isNewMonth()) {
      _hiveService.resetBudgetMonth();
    }

    return _hiveService.getMonthlyBudget();
  }
}
