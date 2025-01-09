import 'dart:convert';

import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/error/exception.dart';
import 'package:money_track/features/group/data/models/group_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class GroupRemoteDataSource {
  Future<GroupModel> createGroup(GroupModel group);
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
}