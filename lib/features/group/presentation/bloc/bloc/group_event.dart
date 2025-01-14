part of 'group_bloc.dart';

abstract class GroupEvent {}

class GroupAdd extends GroupEvent {
  final String? id;
  final String groupName;
  final String groupDescription;
  final String budget;
  final String admin;
  final List<dynamic> members;

  GroupAdd({
    this.id,
    required this.groupName,
    required this.groupDescription,
    required this.budget,
    required this.admin,
    required this.members,
  });
}

class GroupsGetAllGroups extends GroupEvent {}

class GroupEdit extends GroupEvent {
  final String id;
  final String groupName;
  final String groupDescription;
  final String budget;

  GroupEdit({
    required this.id,
    required this.groupName,
    required this.groupDescription,
    required this.budget,
  });
}

class GroupDelete extends GroupEvent {
  final String id;

  GroupDelete({
    required this.id,
  });
}
