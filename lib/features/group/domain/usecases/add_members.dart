import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/domain/repository/group_repository.dart';

class AddMembers {
  final GroupRepository repository;

  AddMembers(this.repository);

  Future<Either<Failure, GroupEntity>> call(AddMembersParams params) async {
    return await repository.addMembers(
      groupId: params.groupId,
      members: params.members,
    );
  }
}

class AddMembersParams {
  final String groupId;
  final List<String> members;

  AddMembersParams({
    required this.groupId,
    required this.members,
  });
}
