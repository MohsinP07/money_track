import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/core/usecases/use_case.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/domain/repository/group_repository.dart';

class GetGroupExpenses
    implements UseCase<List<GroupEntity>, GetGroupExpensesParams> {
  final GroupRepository groupRepository;
  GetGroupExpenses(this.groupRepository);

  @override
  Future<Either<Failure, List<GroupEntity>>> call(
      GetGroupExpensesParams params) async {
    final result =
        await groupRepository.getGroupExpeses(groupId: params.groupId);

    return result.fold(
      (failure) => left(failure),
      (groupEntity) => right([groupEntity]),
    );
  }
}

class GetGroupExpensesParams {
  final String groupId;

  GetGroupExpensesParams({
    required this.groupId,
  });
}
