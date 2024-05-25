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
