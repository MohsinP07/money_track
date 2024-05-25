part of 'expenses_bloc.dart';

abstract class ExpensesEvent {}

class ExpenseAdd extends ExpensesEvent {
  final String expenserId;
  final String expenserName;
  final String name;
  final String description;
  final String amount;
  final DateTime date;
  final String category;

  ExpenseAdd({
    required this.expenserId,
    required this.expenserName,
    required this.name,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });
}

class ExpenseGetAllExpenses extends ExpensesEvent {}

class ExpenseDelete extends ExpensesEvent {
  final String id;

  ExpenseDelete({required this.id});
}

class ExpenseEdit extends ExpensesEvent {
  final String id;
  final String name;
  final String description;
  final String amount;
  final DateTime date;
  final String category;

  ExpenseEdit({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });
}
