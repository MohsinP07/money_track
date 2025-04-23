import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/domain/repository/group_repository.dart';

class RemoveMember {
  final GroupRepository repository;

  RemoveMember(this.repository);

  Future<Either<Failure, GroupEntity>> call(RemoveMemberParams params) async {
    return await repository.removeMember(
      groupId: params.groupId,
      memberId: params.memberId,
    );
  }
}

class RemoveMemberParams {
  final String groupId;
  final String memberId;

  RemoveMemberParams({
    required this.groupId,
    required this.memberId,
  });
}
