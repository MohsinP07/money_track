part of 'group_bloc.dart';

abstract class GroupEvent {}

class GroupAdd extends GroupEvent {
  final String? id;
  final String groupName;
  final String groupDescription;
  final String budget;
  final String admin;
  final List<dynamic> members;
  final Map<String, Object>? groupExpenses;

  GroupAdd({
    this.id,
    required this.groupName,
    required this.groupDescription,
    required this.budget,
    required this.admin,
    required this.members,
    this.groupExpenses,
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

class GroupAddGroupExpenses extends GroupEvent {
  final String id;
  final Map<String, Object> groupExpenses;

  GroupAddGroupExpenses({
    required this.id,
    required this.groupExpenses,
  });
}

class GroupEditGroupExpense extends GroupEvent {
  final String groupId;
  final String expenseId;
  final Map<String, Object> updatedExpense;

  GroupEditGroupExpense({
    required this.groupId,
    required this.expenseId,
    required this.updatedExpense,
  });
}

class GroupDeleteGroupExpense extends GroupEvent {
  final String groupId;
  final String expenseId;

  GroupDeleteGroupExpense({
    required this.groupId,
    required this.expenseId,
  });
}

class GroupRemoveMember extends GroupEvent {
  final String groupId;
  final String memberId;

  GroupRemoveMember({
    required this.groupId,
    required this.memberId,
  });
}

class GroupAddMember extends GroupEvent {
  final String groupId;
  final List<String> members;

  GroupAddMember({
    required this.groupId,
    required this.members,
  });
}
