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
  final bool isEdited;

  ExpenseAdd({
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
  final bool isEdited;

  ExpenseEdit({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    required this.isEdited,
  });
}
