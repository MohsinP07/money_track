import 'dart:convert';

import 'package:money_track/features/expenses/domain/entity/expense.dart';

class ExpenseModel extends Expense {
  ExpenseModel({
    String? id,
    required String expenserId,
    required String expenserName,
    required String name,
    required String description,
    required String amount,
    required DateTime date,
    required String category,
  }) : super(
          id: id,
          expenserId: expenserId,
          expenserName: expenserName,
          name: name,
          description: description,
          amount: amount,
          date: date,
          category: category,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'expenserId': expenserId,
      'expenserName': expenserName,
      'name': name,
      'description': description,
      'amount': amount,
      'date': date.toUtc().toIso8601String(), // Ensure UTC is used
      'category': category,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    String? id;
    if (map['_id'] is Map) {
      id = (map['_id'] as Map<String, dynamic>) as String?;
    } else if (map['_id'] is String) {
      id = map['_id'] as String?;
    }

    return ExpenseModel(
      id: id,
      expenserId: map['expenserId'] as String? ?? '',
      expenserName: map['expenserName'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      amount: map['amount'] as String? ?? '',
      date: map['date'] == null
          ? DateTime.now()
          : DateTime.parse(map['date']).toLocal(), // Ensure local conversion
      category: map['category'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromJson(String source) =>
      ExpenseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Expense copyWith({
    String? id,
    String? expenserId,
    String? expenserName,
    String? name,
    String? description,
    String? amount,
    DateTime? date,
    String? category,
  }) {
    return Expense(
      id: id ?? this.id,
      expenserId: expenserId ?? this.expenserId,
      expenserName: expenserName ?? this.expenserName,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
}
