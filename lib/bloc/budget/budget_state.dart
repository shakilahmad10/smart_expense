import 'package:equatable/equatable.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();
  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final double monthlyBudget;
  const BudgetLoaded(this.monthlyBudget);

  @override
  List<Object?> get props => [monthlyBudget];
}

class BudgetLoading extends BudgetState {}

class BudgetError extends BudgetState {
  final String message;
  const BudgetError(this.message);
}
