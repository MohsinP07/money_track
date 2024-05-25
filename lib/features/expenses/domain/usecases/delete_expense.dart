// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/expenses/domain/repository/expense_repository.dart';

import '../entity/expense.dart';

class DeleteExpense {
  final ExpenseRepository repository;

  DeleteExpense(this.repository);

  Future<Either<Failure, Expense>> call(DeleteExpenseParams params) async {
    return await repository.deleteExpense(id: params.id);
  }
}

class DeleteExpenseParams {
  final String id;
  DeleteExpenseParams({
    required this.id,
  });
}
