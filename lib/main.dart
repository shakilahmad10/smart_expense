import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_expense/bloc/expense/expense_bloc.dart';
import 'package:smart_expense/data/datasource/hive_service.dart';
import 'package:smart_expense/data/repository/expense_repository.dart';
import 'package:smart_expense/models/expense_model.dart';
import 'package:smart_expense/presentation/screens/expense_list_screen.dart';
import 'package:smart_expense/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>('expenses');

  final hiveService = HiveService();
  final expenseRepository = ExpenseRepository(hiveService);

  runApp(MyApp(expenseRepository));
}

class MyApp extends StatelessWidget {
  final ExpenseRepository expenseRepository;
  const MyApp(this.expenseRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpenseBloc(expenseRepository),
      child: const MaterialApp(home: HomeScreen()),
    );
  }
}
