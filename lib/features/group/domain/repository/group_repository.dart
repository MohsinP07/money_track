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
}