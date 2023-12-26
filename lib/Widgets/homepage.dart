
import 'dart:convert';

import 'package:expense_app/Models/expense_par.dart';
import 'package:expense_app/Widgets/ExpenseData/list_expense.dart';
import 'package:expense_app/Widgets/chart/chart.dart';
import 'package:expense_app/inputExpense.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  bool _isLoading = true;
  List<Expenses> _AllExpenses = [];
@override
  void initState() {
    super.initState();
    loadItems();
  }
  void _openModelBottomSheet() async{
   final newItem = await showModalBottomSheet<Expenses>(
        isScrollControlled: true,
        context: context,
        builder: (ctx) =>
            const NewExpense());
   if(newItem == null){
     return;
   }
   setState(() {
      _AllExpenses.add(newItem);
   });

  }
  void loadItems() async {
    final url = Uri.https('expense-tracker-24cf4-default-rtdb.firebaseio.com',
        'expense-tracker.json');
    final response = await http.get(url);
    if(response.body =='null'){
      setState(() {
        _isLoading = false;
      });
    }
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<Expenses> loadedItems = [];

    for (final item in listData.entries) {
      final category = Category.values.firstWhere((element) =>  element.name == item.value['category']);

      loadedItems.add(
        Expenses(
        amt: item.value['amt'],
        title: item.value['title'],
        category: category,
        dte: DateTime.parse(item.value['dte']),),);
    }
    print(response);
    setState(() {
      _AllExpenses = loadedItems;
      _isLoading = false;
    });
  }

  void _removeExpense(Expenses expense) {
    final expenseIndex = _AllExpenses.indexOf(expense);
    setState(() {
      _AllExpenses.remove(expense);
    });
    final url = Uri.https('expense-tracker-24cf4-default-rtdb.firebaseio.com',
        'expense-tracker/${expense.id}.json');
    http.delete(url);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('expense deleted.'),
      action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _AllExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final widdth = MediaQuery
        .of(context)
        .size
        .width;
    Widget mainContent = const Center(
      child: Text('your list is empty please add item on list'),
    );
    if (_AllExpenses.isNotEmpty) {
      mainContent = ExpenseList(
        expenseList: _AllExpenses,
        onRemoveExpenses: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('EXPENSE TRACKER'),
        actions: [
          IconButton(
              onPressed: _openModelBottomSheet, icon: const Icon(Icons.add))
        ],
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: _openModelBottomSheet,
            shape: const CircleBorder(
              side: BorderSide(width: 2),
            ),
            tooltip: 'Add Item',
            child: const Icon(Icons.add),
          ),
        ),
      ),
      body: _isLoading ?Center(child: CircularProgressIndicator(),):widdth < 600
          ? Column(
        children: [
          Chart(expenses: _AllExpenses),
          Expanded(child: mainContent),
        ],
      )
          : Row(
        children: [
          Expanded(child: Chart(expenses: _AllExpenses)),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
