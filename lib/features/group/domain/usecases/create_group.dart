import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/domain/repository/group_repository.dart';

class CreateGroup {
  final GroupRepository repository;

  CreateGroup(this.repository);

  Future<Either<Failure, GroupEntity>> call(CreateGroupParams params) {
    return repository.addGroup(
        groupName: params.groupName,
        groupDescription: params.groupDescription,
        budget: params.budget,
        admin: params.admin,
        members: params.members);
  }
}

class CreateGroupParams {
  final String? id;
  final String groupName;
  final String groupDescription;
  final String budget;
  final String admin;
  final List<dynamic> members;

  CreateGroupParams({
    this.id,
    required this.groupName,
    required this.groupDescription,
    required this.budget,
    required this.admin,
    required this.members,
  });
}
