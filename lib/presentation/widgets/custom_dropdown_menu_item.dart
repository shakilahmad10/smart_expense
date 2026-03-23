import 'package:flutter/material.dart';

class CustomDropdownMenuItem extends StatelessWidget {
  final String valueText;
  final String category;

  const CustomDropdownMenuItem({
    super.key,
    required this.valueText,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem(value: valueText, child: Text(category));
  }
}
