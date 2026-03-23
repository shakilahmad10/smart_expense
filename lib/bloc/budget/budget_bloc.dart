import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_expense/bloc/budget/budget_event.dart';
import 'package:smart_expense/bloc/budget/budget_state.dart';
import 'package:smart_expense/data/repository/budget_repository.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetRepository _budgetRepository;
  BudgetBloc(this._budgetRepository) : super(BudgetInitial()) {
    on<LoadMonthlyBudget>((event, emit) {
      emit(BudgetLoading());
      try {
        final result = _budgetRepository.getMonthlyBudget();
        emit(BudgetLoaded(result));
      } catch (e) {
        emit(const BudgetError("Failed to budget!"));
      }
    });

    on<SetMonthlyBudget>((event, emit) async {
      try {
        await _budgetRepository.saveMonthlyBudget(event.budgetAmount);
        final monthlyBudget = _budgetRepository.getMonthlyBudget();
        emit(BudgetLoaded(monthlyBudget));
      } catch (e) {
        emit(const BudgetError("Failed to add budget"));
      }
    });
  }
}
