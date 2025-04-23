import 'dart:convert';

import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/entity/user.dart';
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
  Future<GroupModel> editGroupExpense(
      String groupId, String expenseId, Map<String, Object> updatedExpense);
  Future<GroupModel> deleteGroupExpense(String groupId, String expenseId);
  Future<GroupModel> removeMember(String groupId, String memberId);
  Future<GroupModel> addMember(String groupId, List<String> members);
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

  @override
  Future<GroupModel> editGroupExpense(String groupId, String expenseId,
      Map<String, Object> updatedExpense) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }

      final response = await http.put(
        Uri.parse('$uri/group/edit-group-expense'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: json.encode({
          'groupId': groupId,
          'expenseId': expenseId,
          'updatedExpense': updatedExpense,
        }),
      );

      if (response.statusCode != 200) {
        throw ServerException(
            'Failed to edit group expense. Status code: ${response.statusCode}');
      }
      final responseBody = json.decode(response.body) as Map<String, dynamic>;

      if (!responseBody.containsKey('group')) {
        throw ServerException('Invalid response format: Missing group key');
      }

      return GroupModel.fromMap(responseBody['group']);
    } catch (e) {
      print('Error editing group expense: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GroupModel> deleteGroupExpense(
      String groupId, String expenseId) async {
    print(groupId);
    print(expenseId);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }

      final response = await http.put(
        Uri.parse('$uri/group/delete-group-expense'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: json.encode({
          'groupId': groupId,
          'expenseId': expenseId,
        }),
      );

      if (response.statusCode != 200) {
        throw ServerException(
            'Failed to delete group expense. Status code: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['group'] != null) {
        return GroupModel.fromMap(responseBody['group']);
      } else {
        throw ServerException('Unexpected response format');
      }
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GroupModel> removeMember(String groupId, String memberId) async {
    try {
      print("fff");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }

      final response = await http.put(
        Uri.parse('$uri/group/remove-member'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: json.encode({
          'groupId': groupId,
          'memberId': memberId,
        }),
      );
      print(response.statusCode);
      if (response.statusCode != 200) {
        throw ServerException(
            'Failed to remove member. Status code: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['group'] != null) {
        return GroupModel.fromMap(responseBody['group']);
      } else {
        throw ServerException('Unexpected response format');
      }
    } catch (e) {
      print('Error removing member: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GroupModel> addMember(String groupId, List<String> members) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }
      print(members);
      final response = await http.put(
        Uri.parse('$uri/group/add-members'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: json.encode({
          'groupId': groupId,
          'memberEmails': members,
        }),
      );

      if (response.statusCode != 200) {
        throw ServerException(
            'Failed to add members. Status code: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['group'] != null) {
        return GroupModel.fromMap(responseBody['group']);
      } else {
        throw ServerException('Unexpected response format');
      }
    } catch (e) {
      print('Error adding members: $e');
      throw ServerException(e.toString());
    }
  }
}
