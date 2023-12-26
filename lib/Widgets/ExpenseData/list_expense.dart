import 'dart:convert';
import 'package:expense_app/Widgets/ExpenseData/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Models/expense_par.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({required this.onRemoveExpenses, super.key,required this.expenseList});

  final void Function(Expenses expense) onRemoveExpenses;

  final List<Expenses> expenseList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenseList.length,
        itemBuilder: (ctx, indx) => Dismissible(
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.8),
              margin: Theme.of(context).cardTheme.margin,
              child: const Icon(Icons.delete),
            ),
            key: ValueKey(expenseList[indx]),
            onDismissed: (direction) {
              onRemoveExpenses(expenseList[indx]);
            },
            child: ExpenseItem(expenseList[indx])));
  }
}
