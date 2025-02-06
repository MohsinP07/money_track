import 'dart:convert';

import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/error/exception.dart';
import 'package:money_track/features/group/data/models/group_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class GroupRemoteDataSource {
  Future<GroupModel> createGroup(GroupModel group);
  Future<List<GroupModel>> getAllGroups();
  Future<GroupModel> editGroup(
      String id, String groupName, String groupDescription, String budget);
  Future<GroupModel> deleteGroup(String id);
  Future<GroupModel> addGroupExpenses(
      String id, Map<String, Object> groupExpenses);
}

class GroupRemoteDataSourceImplement implements GroupRemoteDataSource {
  @override
  Future<GroupModel> createGroup(GroupModel group) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }
      print(group.toJson());
      final response = await http.post(
        Uri.parse('$uri/group/add-group'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: group.toJson(),
      );
      if (response.statusCode != 200) {
        throw ServerException(
            'Failed to add expense. Status code: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = json.decode(response.body);

      return GroupModel.fromMap(responseBody);
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<GroupModel>> getAllGroups() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }

      final response = await http.get(
        Uri.parse('$uri/group/get-groups'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
            'Failed to fetch expenses. Status code: ${response.statusCode}');
      }

      final List<dynamic> responseBody = json.decode(response.body);

      return responseBody
          .map((group) => GroupModel.fromMap(group as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GroupModel> editGroup(String id, String groupName,
      String groupDescription, String budget) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }

      final response = await http.put(
        Uri.parse('$uri/group/edit-group'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: json.encode({
          'id': id,
          'groupName': groupName,
          'groupDescription': groupDescription,
          'budget': budget,
        }),
      );

      if (response.statusCode != 200) {
        throw ServerException(
            'Failed to edit expense. Status code: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = json.decode(response.body);

      return GroupModel.fromMap(responseBody);
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GroupModel> deleteGroup(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }

      final response = await http.post(
        Uri.parse('$uri/group/delete-group'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: json.encode({'id': id}),
      );

      if (response.statusCode != 200) {
        throw ServerException(
            'Failed to delete expense. Status code: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = json.decode(response.body);

      return GroupModel.fromMap(responseBody);
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GroupModel> addGroupExpenses(
      String id, Map<String, Object> groupExpenses) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }

      final response = await http.put(
        Uri.parse('$uri/group/add-group-expense'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: json.encode({
          'id': id,
          'groupExpenses': groupExpenses,
        }),
      );

      if (response.statusCode != 200) {
        throw ServerException(
            'Failed to edit expense. Status code: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = json.decode(response.body);

      return GroupModel.fromMap(responseBody);
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }
}
