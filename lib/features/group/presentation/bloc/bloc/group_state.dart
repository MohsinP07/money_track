part of 'group_bloc.dart';

abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupFailure extends GroupState {
  final String error;

  GroupFailure(this.error);
}

class AddGroupSuccess extends GroupState {}

class GroupsDisplaySuccess extends GroupState {
  final List<GroupEntity> groups;

  GroupsDisplaySuccess(this.groups);
}

class EditGroupSuccess extends GroupState {
  final GroupEntity editedGroup;

  EditGroupSuccess(this.editedGroup);
}

class DeleteGroupSuccess extends GroupState {
  final GroupEntity deletedGroup;
  DeleteGroupSuccess(this.deletedGroup);
}
