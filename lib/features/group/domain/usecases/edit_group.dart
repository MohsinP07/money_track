// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/domain/repository/group_repository.dart';

class EditGroup {
  final GroupRepository repository;

  EditGroup(this.repository);

  Future<Either<Failure, GroupEntity>> call(EditGroupParams params) async {
    return await repository.editGroup(
        id: params.id,
        groupName: params.groupName,
        groupDescription: params.groupDescription,
        budget: params.budget);
  }
}

class EditGroupParams {
  final String id;
  final String groupName;
  final String groupDescription;
  final String budget;

  EditGroupParams({
    required this.id,
    required this.groupName,
    required this.groupDescription,
    required this.budget,
  });
}
