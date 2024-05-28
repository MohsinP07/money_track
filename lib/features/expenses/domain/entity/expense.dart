// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Expense {
  final String? id;
  final String expenserId;
  final String expenserName;
  final String name;
  final String description;
  final String amount;
  final DateTime date;
  final String category;
  final bool isEdited;

  Expense({
    this.id,
    required this.expenserId,
    required this.expenserName,
    required this.name,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    required this.isEdited,
  });
}
