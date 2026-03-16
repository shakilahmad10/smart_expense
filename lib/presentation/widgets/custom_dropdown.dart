// import 'package:flutter/material.dart';

// class CustomDropdown extends StatefulWidget {
//   final String selectedItem;
//   final List<String> items;
//   const CustomDropdown({
//     super.key,
//     required this.selectedItem,
//     required this.items,
//   });

//   @override
//   State<CustomDropdown> createState() => _CustomDropdownState();
// }

// class _CustomDropdownState extends State<CustomDropdown> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 66,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//           prefixIcon: const Icon(Icons.category),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             hint: const Text("Select Expense type"),
//             value: context.widget.selectedItem,
//             isExpanded: true,
//             icon: Icon(
//               Icons.arrow_drop_down,
//               fontWeight: FontWeight.bold,
//               size: 30,
//             ),
//             items: expenseTypes.map((String type) {
//               return DropdownMenuItem<String>(value: type, child: Text(type));
//             }).toList(),
//             onChanged: (newValue) {
//               setState(() {
//                 selectedCategory = newValue;
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
