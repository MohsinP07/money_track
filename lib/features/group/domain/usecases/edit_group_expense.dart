// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/domain/repository/group_repository.dart';

class EditGroupExpense {
  final GroupRepository repository;

  EditGroupExpense(this.repository);

  Future<Either<Failure, GroupEntity>> call(
      EditGroupExpensesParam params) async {
    return await repository.editGroupExpense(
      groupId: params.groupId,
      expenseId: params.expenseId,
      updatedExpense: params.updatedExpense,
    );
  }
}

class EditGroupExpensesParam {
  final String groupId;
  final String expenseId;
  final Map<String, Object> updatedExpense;

  EditGroupExpensesParam({
    required this.groupId,
    required this.expenseId,
    required this.updatedExpense,
  });
}
