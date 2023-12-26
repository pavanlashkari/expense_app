import 'dart:convert';

import 'package:flutter/material.dart';

import 'Models/expense_par.dart';
import 'package:http/http.dart' as http;

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amtController = TextEditingController();
  DateTime? yourDate;
  Category _selectedDropDownItem = Category.food;

  void _showDatePicker() async {
    final now = DateTime.now();
    final firstDate = now.year - 1;
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(firstDate),
        lastDate: DateTime.now());
    setState(() {
      yourDate = selectedDate;
    });
  }

  String formatDate(String value) {
    String formattedDate =
        '${yourDate?.day}/${yourDate?.month}/${yourDate?.year}';
    return formattedDate;
  }

  Future<void> _addExpense(Expenses expense) async {
    final enteredAmont = double.tryParse(_amtController.text);
    final amountIsInvalid = enteredAmont == null;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        yourDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input!'),
          content: const Text('please make sure you entered all field data'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('OK'))
          ],
        ),
      );
      return;
    }

    final url = Uri.https('expense-tracker-24cf4-default-rtdb.firebaseio.com',
        'expense-tracker.json');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'amt': expense.amt,
        'title': expense.title,
        'category': expense.category.name,
        'dte': expense.dte.toString(),
      },
      ),
    );
    final Map<String, dynamic> resData = json.decode(response.body);
    Navigator.of(context).pop(Expenses(
        id: resData['name'],
        amt: expense.amt,
        title: expense.title,
        category: expense.category,
        dte: expense.dte));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, keyboardSize + 20),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    label: Text("Title"),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _amtController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            label: Text('amount'), prefixText: '\$ '),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(yourDate == null
                              ? "select DAte"
                              : formatDate(yourDate.toString())),
                          IconButton(
                              onPressed: _showDatePicker,
                              icon: const Icon(Icons.calendar_month_outlined)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    DropdownButton(
                        value: _selectedDropDownItem,
                        items: Category.values
                            .map((Category) => DropdownMenuItem(
                                value: Category,
                                child: Text(Category.name.toUpperCase())))
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedDropDownItem = value;
                          });
                        }),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('cancel')),
                    ElevatedButton(
                      onPressed: () {
                        _addExpense(
                          Expenses(
                              amt: double.tryParse(_amtController.text)!,
                              title: _titleController.text,
                              category: _selectedDropDownItem,
                              dte: yourDate!),
                        );
                      },
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)))),
                      child: const Text('Add expense'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
