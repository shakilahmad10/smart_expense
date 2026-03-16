import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_expense/bloc/expense/expense_bloc.dart';
import 'package:smart_expense/bloc/expense/expense_event.dart';
import 'package:smart_expense/models/expense_model.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedCategory;

  final List<String> expenseTypes = [
    "Food",
    "Transport",
    "Entertainment",
    "Shopping",
    "Bills",
    "Other",
  ];

  String? selectedPaymentType;
  final List<String> paymentTypes = ["Cash", "Card", "UPI", "Other"];

  @override
  void initState() {
    super.initState();

    amountController.text = widget.expense.amount.toString();
    descriptionController.text = widget.expense.description.toString();

    selectedCategory = widget.expense.category;
    selectedPaymentType = widget.expense.paymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Expense")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Amount
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  prefixIcon: const Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 20,
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter amount' : null,
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              SizedBox(
                height: 66,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: const Text("Select Category"),
                      value: selectedCategory,
                      isExpanded: true,
                      items: expenseTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Payment Type Dropdown
              SizedBox(
                height: 66,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.payment),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: const Text("Select Payment Type"),
                      value: selectedPaymentType,
                      isExpanded: true,
                      items: paymentTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedPaymentType = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Description
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Expense Description",
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 20,
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedExpense = Expense(
                        id: widget.expense.id,
                        amount: double.parse(amountController.text.trim()),
                        description: descriptionController.text.trim(),
                        category: selectedCategory ?? "Other",
                        dateTime: widget.expense.dateTime,
                        paymentMethod: "Cash",
                      );

                      // Trigger BLoC event
                      context.read<ExpenseBloc>().add(
                        UpdateExpense(updatedExpense),
                      );

                      Navigator.pop(context); // Go back to list
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 22, 143, 183),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Update Expense",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
