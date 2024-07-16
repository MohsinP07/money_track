// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/auth/domain/repository/auth_repository.dart';

class DeleteAllExpenses {
  final AuthRepository repository;

  DeleteAllExpenses(this.repository);

  Future<Either<Failure, void>> call(DeleteAllExpensesParams params) async {
    return await repository.deleteAllUserExpenses(
      expenserId: params.expenserId,
    );
  }
}

class DeleteAllExpensesParams {
  final String expenserId;

  DeleteAllExpensesParams({
    required this.expenserId,
  });
}
