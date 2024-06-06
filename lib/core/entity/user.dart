// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
  });
}
