// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/features/expenses/domain/repository/expense_repository.dart';

class EditExpense {
  final ExpenseRepository repository;

  EditExpense(this.repository);

  Future<Either<Failure, Expense>> call(EditExpenseParams params) async {
    return await repository.editExpense(
      id: params.id,
      name: params.name,
      amount: params.amount,
      description: params.description,
      date: params.date,
      category: params.category,
      isEdited: params.isEdited,
    );
  }
}

class EditExpenseParams {
  final String id;
  final String name;
  final String amount;
  final String description;
  final DateTime date;
  final String category;
  final bool isEdited;

  EditExpenseParams({
    required this.id,
    required this.name,
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
    required this.isEdited,
  });
}
