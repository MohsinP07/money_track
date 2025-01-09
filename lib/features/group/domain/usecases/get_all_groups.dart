import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/core/usecases/use_case.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/domain/repository/group_repository.dart';

class GetAllGroups implements UseCase<List<GroupEntity>, NoParams> {
  final GroupRepository groupRepository;
  GetAllGroups(this.groupRepository);

  @override
  Future<Either<Failure, List<GroupEntity>>> call(NoParams params) async {
    return await groupRepository.getAllGroups();
  }
}
