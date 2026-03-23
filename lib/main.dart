import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_expense/bloc/budget/budget_bloc.dart';
import 'package:smart_expense/bloc/expense/expense_bloc.dart';
import 'package:smart_expense/data/datasource/hive_service.dart';
import 'package:smart_expense/data/repository/budget_repository.dart';
import 'package:smart_expense/data/repository/expense_repository.dart';
import 'package:smart_expense/models/expense_model.dart';
import 'package:smart_expense/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox("settings");

  final hiveService = HiveService();
  final expenseRepository = ExpenseRepository(hiveService);
  final budgetRepository = BudgetRepository(hiveService);

  runApp(MyApp(expenseRepository, budgetRepository));
}

class MyApp extends StatelessWidget {
  final ExpenseRepository expenseRepository;
  final BudgetRepository budgetRepository;
  const MyApp(this.expenseRepository, this.budgetRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ExpenseBloc(expenseRepository)),
        BlocProvider(create: (_) => BudgetBloc(budgetRepository)),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
