import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:money_track/features/group/domain/usecases/create_group.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final CreateGroup _createGroup;

  GroupBloc({
    required CreateGroup addExpense,
  })  : _createGroup = addExpense,
        super(GroupInitial()) {
    on<GroupAdd>(_onAddGroup);
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
}
