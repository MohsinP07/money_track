class GroupEntity {
  String? id;
  String groupName;
  String groupDescription;
  String budget;
  String admin;
  List<dynamic> members;

  GroupEntity({
    this.id,
    required this.groupName,
    required this.groupDescription,
    required this.budget,
    required this.admin,
    required this.members,
  });

  GroupEntity copyWith({
    String? id,
    String? groupName,
    String? groupDescription,
    String? budget,
    String? admin,
    List<dynamic>? members,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      groupName: groupName ?? this.groupName,
      groupDescription: groupDescription ?? this.groupDescription,
      budget: budget ?? this.budget,
      admin: admin ?? this.admin,
      members: members ?? this.members,
    );
  }
}
