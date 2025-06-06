// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/domain/repository/group_repository.dart';

class DeleteGroupExpense {
  final GroupRepository repository;

  DeleteGroupExpense(this.repository);

  Future<Either<Failure, GroupEntity>> call(
      DeleteGroupExpensesParam params) async {
    return await repository.deleteGroupExpense(
      groupId: params.groupId,
      expenseId: params.expenseId,
    );
  }
}

class DeleteGroupExpensesParam {
  final String groupId;
  final String expenseId;

  DeleteGroupExpensesParam({
    required this.groupId,
    required this.expenseId,
  });
}
