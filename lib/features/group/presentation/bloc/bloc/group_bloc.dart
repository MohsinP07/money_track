import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:money_track/core/usecases/use_case.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/domain/usecases/create_group.dart';
import 'package:money_track/features/group/domain/usecases/get_all_groups.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final CreateGroup _createGroup;
  final GetAllGroups _getAllGroups;

  GroupBloc({
    required CreateGroup addExpense,
    required GetAllGroups getAllGroups,
  })  : _createGroup = addExpense,
        _getAllGroups = getAllGroups,
        super(GroupInitial()) {
    on<GroupAdd>(_onAddGroup);
    on<GroupsGetAllGroups>(_onFetchAllGroups);
  }

  void _onAddGroup(GroupAdd event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    final res = await _createGroup(CreateGroupParams(
        groupName: event.groupName,
        groupDescription: event.groupDescription,
        budget: event.budget,
        admin: event.admin,
        members: event.members));

    res.fold(
      (failure) => emit(GroupFailure(failure.message)),
      (expense) => emit(AddGroupSuccess()),
    );
  }

  void _onFetchAllGroups(
      GroupsGetAllGroups event, Emitter<GroupState> emit) async {
    emit(GroupLoading()); // Emit loading state before processing
    final res = await _getAllGroups(NoParams());
    res.fold(
        (l) => emit(GroupFailure(l.message)),
        (r) => emit(
              GroupsDisplaySuccess(r),
            ));
  }
}
