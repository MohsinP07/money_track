import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/exception.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/group/data/datasources/group_remote_data_source.dart';
import 'package:money_track/features/group/data/models/group_model.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/domain/repository/group_repository.dart';

class GroupRepositoryImplement implements GroupRepository {
  final GroupRemoteDataSource groupRemoteDataSource;
  GroupRepositoryImplement(this.groupRemoteDataSource);

  @override
  Future<Either<Failure, GroupEntity>> addGroup(
      {String? id,
      required String groupName,
      required String groupDescription,
      required String budget,
      required String admin,
      required List members}) async {
    try {
      GroupModel groupModel = GroupModel(
          groupName: groupName,
          groupDescription: groupDescription,
          budget: budget,
          admin: admin,
          members: members);

      final addedGroup = await groupRemoteDataSource.createGroup(groupModel);
      return right(addedGroup);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroupEntity>>> getAllGroups() async {
    try {
      final groups = await groupRemoteDataSource.getAllGroups();

      return right(groups);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
