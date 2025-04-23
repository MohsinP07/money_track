import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/usecases/use_case.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/domain/usecases/add_group_expenses.dart';
import 'package:money_track/features/group/domain/usecases/add_members.dart';
import 'package:money_track/features/group/domain/usecases/create_group.dart';
import 'package:money_track/features/group/domain/usecases/delete_group.dart';
import 'package:money_track/features/group/domain/usecases/delete_group_expense.dart';
import 'package:money_track/features/group/domain/usecases/edit_group.dart';
import 'package:money_track/features/group/domain/usecases/get_all_groups.dart';
import 'package:money_track/features/group/domain/usecases/edit_group_expense.dart';
import 'package:money_track/features/group/domain/usecases/remove_member.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final CreateGroup _createGroup;
  final GetAllGroups _getAllGroups;
  final EditGroup _editGroup;
  final DeleteGroup _deleteGroup;
  final AddGroupExpenses _addGroupExpenses;
  final EditGroupExpense _editGroupExpense;
  final DeleteGroupExpense _deleteGroupExpense;
  final RemoveMember _removeMember;
  final AddMembers _addMembers;

  GroupBloc({
    required CreateGroup addExpense,
    required GetAllGroups getAllGroups,
    required EditGroup editGroup,
    required DeleteGroup deleteGroup,
    required AddGroupExpenses addGroupExpenses,
    required EditGroupExpense editGroupExpense,
    required DeleteGroupExpense deleteGroupExpense,
    required RemoveMember removeMember,
    required AddMembers addMembers,
  })  : _createGroup = addExpense,
        _getAllGroups = getAllGroups,
        _editGroup = editGroup,
        _deleteGroup = deleteGroup,
        _addGroupExpenses = addGroupExpenses,
        _editGroupExpense = editGroupExpense,
        _deleteGroupExpense = deleteGroupExpense,
        _removeMember = removeMember,
        _addMembers = addMembers,
        super(GroupInitial()) {
    on<GroupAdd>(_onAddGroup);
    on<GroupsGetAllGroups>(_onFetchAllGroups);
    on<GroupEdit>(_onEditGroup);
    on<GroupDelete>(_onDeleteGroup);
    on<GroupAddGroupExpenses>(_onAddGroupExpenses);
    on<GroupEditGroupExpense>(_onEditGroupExpense);
    on<GroupDeleteGroupExpense>(_onDeleteGroupExpense);
    on<GroupRemoveMember>(_onRemoveMember);
    on<GroupAddMember>(_onAddMember);
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
    emit(GroupLoading());
    final res = await _getAllGroups(NoParams());
    res.fold(
      (l) => emit(GroupFailure(l.message)),
      (r) => emit(GroupsDisplaySuccess(r)),
    );
  }

  Future<void> _onEditGroup(GroupEdit event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    final result = await _editGroup(EditGroupParams(
        id: event.id,
        groupName: event.groupName,
        groupDescription: event.groupDescription,
        budget: event.budget));
    result.fold(
      (failure) => emit(GroupFailure(failure.message)),
      (editedGroup) => emit(EditGroupSuccess(editedGroup)),
    );
  }

  Future<void> _onDeleteGroup(
      GroupDelete event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    final result = await _deleteGroup(DeleteGroupParams(id: event.id));
    result.fold(
      (failure) => emit(GroupFailure(failure.message)),
      (deletedGroup) => emit(DeleteGroupSuccess(deletedGroup)),
    );
  }

  Future<void> _onAddGroupExpenses(
      GroupAddGroupExpenses event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    final result = await _addGroupExpenses(AddGroupExpensesParams(
        id: event.id, groupExpenses: event.groupExpenses));
    result.fold(
      (failure) => emit(GroupFailure(failure.message)),
      (updatedGroup) => emit(AddGroupExpensesSuccess(updatedGroup)),
    );
  }

  Future<void> _onEditGroupExpense(
      GroupEditGroupExpense event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    final result = await _editGroupExpense(EditGroupExpensesParam(
        groupId: event.groupId,
        expenseId: event.expenseId,
        updatedExpense: event.updatedExpense));
    result.fold(
      (failure) => emit(GroupFailure(failure.message)),
      (updatedGroup) => emit(EditGroupExpenseSuccess(updatedGroup)),
    );
  }

  Future<void> _onDeleteGroupExpense(
      GroupDeleteGroupExpense event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    final result = await _deleteGroupExpense(DeleteGroupExpensesParam(
      groupId: event.groupId,
      expenseId: event.expenseId,
    ));
    result.fold(
      (failure) => emit(GroupFailure(failure.message)),
      (updatedGroup) => emit(DeleteGroupExpenseSuccess(updatedGroup)),
    );
  }

  Future<void> _onRemoveMember(
      GroupRemoveMember event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    final result = await _removeMember(RemoveMemberParams(
      groupId: event.groupId,
      memberId: event.memberId,
    ));

    result.fold(
      (failure) => emit(GroupFailure(failure.message)),
      (updatedGroup) => emit(RemoveMemberSuccess(updatedGroup)),
    );
  }

  Future<void> _onAddMember(
      GroupAddMember event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    final result = await _addMembers(AddMembersParams(
      groupId: event.groupId,
      members: event.members,
    ));

    result.fold(
      (failure) => emit(GroupFailure(failure.message)),
      (updatedGroup) => emit(AddMemberSuccess(updatedGroup)),
    );
  }
}
