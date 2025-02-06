// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/domain/repository/group_repository.dart';

class AddGroupExpenses {
  final GroupRepository repository;

  AddGroupExpenses(this.repository);

  Future<Either<Failure, GroupEntity>> call(
      AddGroupExpensesParams params) async {
    return await repository.addGroupExpenses(
      id: params.id,
      groupExpenses: params.groupExpenses,
    );
  }
}

class AddGroupExpensesParams {
  final String id;
  final Map<String, Object> groupExpenses;

  AddGroupExpensesParams({
    required this.id,
    required this.groupExpenses,
  });
}
