import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/core/usecases/use_case.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/features/expenses/domain/repository/expense_repository.dart';

class GetAllExpenses implements UseCase<List<Expense>, NoParams> {
  final ExpenseRepository expenseRepository;
  GetAllExpenses(this.expenseRepository);

  @override
  Future<Either<Failure, List<Expense>>> call(NoParams params) async {
    return await expenseRepository.getAllExpenses();
  }
}
