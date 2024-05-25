import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/exception.dart';
import 'package:money_track/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:money_track/features/expenses/data/models/expense_model.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/expenses/domain/repository/expense_repository.dart';
import 'package:uuid/uuid.dart';

class ExpenseRepositoryImplement implements ExpenseRepository {
  final ExpenseRemoteDataSource expenseRemoteDataSource;
  ExpenseRepositoryImplement(this.expenseRemoteDataSource);

  @override
  Future<Either<Failure, Expense>> addExpense({
    required String name,
    required String amount,
    required String description,
    required DateTime date,
    required String category,
    required String expenserName,
    required String expenserId, // Corrected parameter name
  }) async {
    try {
      ExpenseModel expenseModel = ExpenseModel(
        name: name,
        description: description,
        amount: amount,
        date: date,
        category: category,
        expenserName: expenserName,
        expenserId: expenserId, // Corrected parameter name
      );

      final addedExpense =
          await expenseRemoteDataSource.addExpense(expenseModel);
      return right(addedExpense);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getAllExpenses() async {
    try {
      final expenses = await expenseRemoteDataSource.getAllExpenses();

      return right(expenses);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
