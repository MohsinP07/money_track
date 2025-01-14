// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/domain/repository/group_repository.dart';

class DeleteGroup {
  final GroupRepository repository;

  DeleteGroup(this.repository);

  Future<Either<Failure, GroupEntity>> call(DeleteGroupParams params) async {
    return await repository.deleteGroup(
      id: params.id,
    );
  }
}

class DeleteGroupParams {
  final String id;

  DeleteGroupParams({
    required this.id,
  });
}
