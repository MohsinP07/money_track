import 'dart:convert';
import 'package:money_track/features/group/domain/entity/group.dart';

class GroupModel extends GroupEntity {
  GroupModel({
    String? id,
    required String groupName,
    required String groupDescription,
    required String budget,
    required String admin,
    required List<dynamic> members,
    List<Map<String, dynamic>>? groupExpenses,
  }) : super(
          id: id,
          groupName: groupName,
          groupDescription: groupDescription,
          budget: budget,
          admin: admin,
          members: members,
          groupExpenses: groupExpenses ?? [], // Default to empty list
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'groupName': groupName,
      'groupDescription': groupDescription,
      'budget': budget,
      'admin': admin,
      'members': members,
      'groupExpenses': groupExpenses,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    String? id;

    if (map['_id'] is Map) {
      id = (map['_id'] as Map<String, dynamic>)['_id'] as String?;
    } else if (map['_id'] is String) {
      id = map['_id'] as String?;
    }

    final groupExpenses = map['groupExpenses'] != null
        ? List<Map<String, dynamic>>.from(
            (map['groupExpenses'] as List<dynamic>)
                .map((expense) => expense as Map<String, dynamic>),
          )
        : null;

    return GroupModel(
      id: id,
      groupName: map['groupName'] as String? ?? '',
      groupDescription: map['groupDescription'] as String? ?? '',
      budget: map['budget'] as String? ?? '',
      admin: map['admin'] as String? ?? '',
      members: map['members'] as List<dynamic>,
      groupExpenses: groupExpenses,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  GroupModel copyWith({
    String? id,
    String? groupName,
    String? groupDescription,
    String? budget,
    String? admin,
    List<dynamic>? members,
    List<Map<String, dynamic>>? groupExpenses,
  }) {
    return GroupModel(
      id: id ?? this.id,
      groupName: groupName ?? this.groupName,
      groupDescription: groupDescription ?? this.groupDescription,
      budget: budget ?? this.budget,
      admin: admin ?? this.admin,
      members: members ?? this.members,
      groupExpenses: groupExpenses ?? this.groupExpenses,
    );
  }

  // toEntity method to convert GroupModel to GroupEntity
  GroupEntity toEntity() {
    return GroupEntity(
      id: this.id,
      groupName: this.groupName,
      groupDescription: this.groupDescription,
      budget: this.budget,
      admin: this.admin,
      members: this.members,
      groupExpenses: this.groupExpenses,
    );
  }
}
