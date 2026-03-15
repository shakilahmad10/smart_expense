import 'package:equatable/equatable.dart';
import 'package:smart_expense/models/expense_model.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  const ExpenseLoaded(this.expenses);

  @override
  List<Object?> get props => [expenses];
}

class ExpenseLoading extends ExpenseState {}

class ExpenseError extends ExpenseState {
  final String message;
  const ExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}
