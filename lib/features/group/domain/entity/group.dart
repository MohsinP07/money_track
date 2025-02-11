class GroupEntity {
  String? id;
  String groupName;
  String groupDescription;
  String budget;
  String admin;
  List<dynamic> members;
  List<Map<String, dynamic>>? groupExpenses; // Updated type

  GroupEntity({
    this.id,
    required this.groupName,
    required this.groupDescription,
    required this.budget,
    required this.admin,
    required this.members,
    this.groupExpenses, // Optional
  });

  GroupEntity copyWith({
    String? id,
    String? groupName,
    String? groupDescription,
    String? budget,
    String? admin,
    List<dynamic>? members,
    List<Map<String, dynamic>>? groupExpenses, // Consistent type
  }) {
    return GroupEntity(
      id: id ?? this.id,
      groupName: groupName ?? this.groupName,
      groupDescription: groupDescription ?? this.groupDescription,
      budget: budget ?? this.budget,
      admin: admin ?? this.admin,
      members: members ?? this.members,
      groupExpenses: groupExpenses ?? this.groupExpenses, // Fixed assignment
    );
  }
}
