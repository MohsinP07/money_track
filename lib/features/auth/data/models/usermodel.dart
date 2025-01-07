import 'dart:convert';

import 'package:money_track/core/entity/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String name,
    required String email,
    String phone = '',
  }) : super(id: id, name: name, email: email, phone: phone);

  /// Factory to create a single UserModel from a JSON object
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
    );
  }

  /// Factory to create a list of UserModels from a JSON list
  static List<UserModel> fromJsonList(List<dynamic> list) {
    return list
        .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  /// Method to convert a list of UserModels to a JSON array
  static String toJsonList(List<UserModel> users) {
    final List<Map<String, dynamic>> mappedUsers =
        users.map((user) => user.toMap()).toList();
    return json.encode(mappedUsers);
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
