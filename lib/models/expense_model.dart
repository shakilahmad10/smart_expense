import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String description;

  @HiveField(3)
  String category;

  @HiveField(4)
  DateTime dateTime;

  @HiveField(5)
  String paymentMethod;

  Expense({
    required this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.dateTime,
    required this.paymentMethod,
  });
}
