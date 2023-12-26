import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uid = Uuid();

enum Category { food, travel, book, clothing }

const categoryIcons = {
  Category.food: Icons.food_bank,
  Category.book: Icons.book,
  Category.clothing: Icons.bluetooth_audio,
  Category.travel: Icons.flight_takeoff,
};

class Expenses {
  Expenses({
    this.id = '-1',
    required this.amt,
    required this.title,
    required this.category,
    required this.dte,
  }) ;

  String id;
  final String title;
  final double amt;
  final Category category;
  final DateTime dte;

  String get FormatDate {
    String date = "${dte.day}/${dte.month}/${dte.year}";
    return date;
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  final Category category;
  final List<Expenses> expenses;

  ExpenseBucket.forCategory(List<Expenses> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  double get sumExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amt;
    }
    return sum;
  }
}
