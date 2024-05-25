import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/features/expenses/domain/repository/expense_repository.dart';

class AddExpense {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  Future<Either<Failure, Expense>> call(AddExpenseParams params) {
    return repository.addExpense(
      expenserId: params.expenserId,
      expenserName: params.expenserName,
      name: params.name,
      description: params.description,
      amount: params.amount,
      date: params.date,
      category: params.category,
    );
  }
}

class AddExpenseParams {
  final String expenserId;
  final String expenserName;
  final String name;
  final String description;
  final String amount;
  final DateTime date;
  final String category;

  AddExpenseParams({
    required this.expenserId,
    required this.expenserName,
    required this.name,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });
}
