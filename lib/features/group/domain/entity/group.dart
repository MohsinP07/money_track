class GroupEntity {
  String? id;
  String groupName;
  String groupDescription;
  String budget;
  String admin;
  List<dynamic> members;
  Map<String, Object>? groupExpenses;

  GroupEntity({
    this.id,
    required this.groupName,
    required this.groupDescription,
    required this.budget,
    required this.admin,
    required this.members,
    this.groupExpenses
  });

  GroupEntity copyWith({
    String? id,
    String? groupName,
    String? groupDescription,
    String? budget,
    String? admin,
    List<dynamic>? members,
    Map<String, Object>? groupExpenses,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      groupName: groupName ?? this.groupName,
      groupDescription: groupDescription ?? this.groupDescription,
      budget: budget ?? this.budget,
      admin: admin ?? this.admin,
      members: members ?? this.members,
      groupExpenses: groupExpenses ?? this.groupExpenses
    );
  }
}
