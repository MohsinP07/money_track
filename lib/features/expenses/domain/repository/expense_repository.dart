import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, Expense>> addExpense({
    required String name,
    required String amount,
    required String description,
    required DateTime date,
    required String category,
    required String expenserName,
    required String expenserId,
    required bool isEdited,
  });

  Future<Either<Failure, List<Expense>>> getAllExpenses();

  Future<Either<Failure, Expense>> editExpense({
    required String id,
    required String name,
    required String amount,
    required String description,
    required DateTime date,
    required String category,
    required bool isEdited,
  });

  Future<Either<Failure, Expense>> deleteExpense({
    required String id,
  });
}
