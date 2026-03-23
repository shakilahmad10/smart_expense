import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_expense/bloc/budget/budget_bloc.dart';
import 'package:smart_expense/bloc/budget/budget_event.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            //General Settings
            const Text(
              "General",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(16),
              ),
              child: Column(
                children: [
                  ///Currency
                  ListTile(
                    leading: const Icon(Icons.currency_rupee),
                    title: const Text("Currency"),
                    subtitle: const Text("INR (₹)"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),

                  const Divider(height: 1),

                  ///Dar Mode
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode),
                    title: const Text("Dark Mode"),
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = !isDarkMode;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            //Data
            Text(
              "Data Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet),
                    title: const Text("Monthly Budget"),
                    subtitle: const Text("Set your spending limit"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      showBudgetDialog();
                    },
                  ),

                  const Divider(height: 1),

                  ///Download data
                  ListTile(
                    leading: Icon(Icons.file_download),
                    title: Text("Export Expenses"),
                    subtitle: Text("Export to Excel/PDF"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: Icon(Icons.delete_forever, color: Colors.red),
                    title: Text("Clear All Expenses"),
                    subtitle: Text("Delete all stored expenses"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text(
                            "Are you sure you want to delete all expenses?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ABOUT SECTION
            const Text(
              "About",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text("About App"),
                    subtitle: const Text("Smart Expense Tracker"),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.code),
                    title: const Text("Version"),
                    subtitle: const Text("1.0.0"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void showBudgetDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Set Monthly Budget"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter budget amount",
              prefixText: "₹ ",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final budget = double.tryParse(controller.text);

                if (budget != null) {
                  // Save budget to storage
                  context.read<BudgetBloc>().add(SetMonthlyBudget(budget));
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
