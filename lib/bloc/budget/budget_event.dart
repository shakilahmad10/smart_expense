import 'package:equatable/equatable.dart';

abstract class BudgetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMonthlyBudget extends BudgetEvent {}

class SetMonthlyBudget extends BudgetEvent {
  final double budgetAmount;
  SetMonthlyBudget(this.budgetAmount);

  @override
  List<Object?> get props => [budgetAmount];
}
