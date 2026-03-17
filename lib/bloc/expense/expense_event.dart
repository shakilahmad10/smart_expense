import 'package:equatable/equatable.dart';
import 'package:smart_expense/models/expense_model.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final Expense expense;
  const AddExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DeleteExpense extends ExpenseEvent {
  final String id;
  const DeleteExpense(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateExpense extends ExpenseEvent {
  final Expense expense;
  const UpdateExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class SearchExpenses extends ExpenseEvent {
  final String query;
  const SearchExpenses(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterExpenses extends ExpenseEvent {
  final String category;
  const FilterExpenses(this.category);

  @override
  List<Object?> get props => [category];
}

class SortExpenses extends ExpenseEvent {
  final String sortBy; // e.g., "date", "amount"
  const SortExpenses(this.sortBy);

  @override
  List<Object?> get props => [sortBy];
}

//SORT EVENTS
class SortExpensesByDateAsc extends ExpenseEvent {}

class SortExpensesByDateDesc extends ExpenseEvent {}

class SortExpensesByAmountAsc extends ExpenseEvent {}

class SortExpensesByAmountDesc extends ExpenseEvent {}
