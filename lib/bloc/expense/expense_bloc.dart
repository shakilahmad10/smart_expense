import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_expense/bloc/expense/expense_event.dart';
import 'package:smart_expense/bloc/expense/expense_state.dart';
import 'package:smart_expense/data/repository/expense_repository.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository expenseRepository;
  ExpenseBloc(this.expenseRepository) : super(ExpenseInitial()) {
    on<LoadExpenses>((event, emit) {
      emit(ExpenseLoading());
      try {
        final expenses = expenseRepository.getAllExpenses();
        emit(ExpenseLoaded(expenses));
      } catch (e) {
        emit(const ExpenseError("Failed to load Expenses"));
      }
    });

    on<AddExpense>((event, emit) async {
      try {
        await expenseRepository.addExpense(event.expense);
        final expenses = expenseRepository.getAllExpenses();
        emit(ExpenseLoaded(expenses));
      } catch (e) {
        emit(const ExpenseError("Failed to add Expense"));
      }
    });

    on<DeleteExpense>((event, emit) async {
      try {
        await expenseRepository.deleteExpense(event.id);
        final expenses = expenseRepository.getAllExpenses();
        emit(ExpenseLoaded(expenses));
      } catch (e) {
        emit(const ExpenseError("Failed to delete expense"));
      }
    });

    on<UpdateExpense>((event, emit) async {
      try {
        await expenseRepository.updateExpense(event.expense);
        final expenses = expenseRepository.getAllExpenses();
        emit(ExpenseLoaded(expenses));
      } catch (e) {
        emit(const ExpenseError("Failed to update expense"));
      }
    });

    on<SortExpensesByDateAsc>((event, emit) {
      if (state is ExpenseLoaded) {
        final expenses = List.of((state as ExpenseLoaded).expenses);
        expenses.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        emit(ExpenseLoaded(expenses));
      }
    });

    on<SortExpensesByDateDesc>((event, emit) {
      if (state is ExpenseLoaded) {
        final expenses = List.of((state as ExpenseLoaded).expenses);
        expenses.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        emit(ExpenseLoaded(expenses));
      }
    });

    on<SortExpensesByAmountDesc>((event, emit) {
      if (state is ExpenseLoaded) {
        final expenses = List.of((state as ExpenseLoaded).expenses);
        expenses.sort((a, b) => b.amount.compareTo(a.amount));
        emit(ExpenseLoaded(expenses));
      }
    });

    on<SortExpensesByAmountAsc>((event, emit) {
      if (state is ExpenseLoaded) {
        final expenses = List.of((state as ExpenseLoaded).expenses);
        expenses.sort((a, b) => a.amount.compareTo(b.amount));
        emit(ExpenseLoaded(expenses));
      }
    });
  }
}
