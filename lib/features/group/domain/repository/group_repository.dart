import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/group/domain/entity/group.dart';

abstract class GroupRepository {
  Future<Either<Failure, GroupEntity>> addGroup({
    String id,
    required String groupName,
    required String groupDescription,
    required String budget,
    required String admin,
    required List<dynamic> members,
  });

  Future<Either<Failure, List<GroupEntity>>> getAllGroups();

  Future<Either<Failure, GroupEntity>> editGroup({
    required String id,
    required String groupName,
    required String groupDescription,
    required String budget,
  });

  Future<Either<Failure, GroupEntity>> deleteGroup({
    required String id,
  });

  Future<Either<Failure, GroupEntity>> addGroupExpenses({
    required String id,
    required Map<String, Object> groupExpenses,
  });

  Future<Either<Failure, GroupEntity>> editGroupExpense({
    required String groupId,
    required String expenseId,
    required Map<String, Object> updatedExpense,
  });

  Future<Either<Failure, GroupEntity>> deleteGroupExpense({
    required String groupId,
    required String expenseId,
  });
}
