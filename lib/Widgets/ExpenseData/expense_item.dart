import 'package:flutter/material.dart';

import '../../Models/expense_par.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expenseItem, {super.key});

  final Expenses expenseItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expenseItem.title.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(" \$ ${expenseItem.amt.toStringAsFixed(2)}"),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expenseItem.category]),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(expenseItem.FormatDate),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
