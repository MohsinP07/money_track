class GroupEntity {
  final String? id;
  final String groupName;
  final String groupDescription;
  final String budget;
  final String admin;
  final List<dynamic> members;

  GroupEntity({
    this.id,
    required this.groupName,
    required this.groupDescription,
    required this.budget,
    required this.admin,
    required this.members,
  });
}
