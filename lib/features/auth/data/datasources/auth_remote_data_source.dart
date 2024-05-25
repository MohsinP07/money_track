import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/error/exception.dart';
import 'package:money_track/features/auth/data/models/usermodel.dart';
import 'package:http/http.dart' as http;
import 'package:money_track/features/auth/presentation/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUpEithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  void logOutUser(BuildContext context);
}

class AuthRemoteDataSourceImplement implements AuthRemoteDataSource {
  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/auth/signin'),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (res.statusCode != 200) {
        throw ServerException(
            'Failed to sign in. Status code: ${res.statusCode}');
      }

      Map<String, dynamic> resBody = json.decode(res.body);

      // Store the token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('x-auth-token', resBody['token']);

      return UserModel.fromJson(resBody);
    } catch (e) {
      print(e);

      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpEithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      print("Creating user model...");
      UserModel user = UserModel(
        id: '',
        name: name,
        email: email,
      );
      Map<String, dynamic> userMap = user.toMap();
      userMap['password'] = password; // Add password to the map

      print("User model: ${userMap}");

      http.Response res = await http.post(
        Uri.parse('$uri/auth/signup'),
        body: json.encode(userMap),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print("Response body: ${res.body}");

      if (res.statusCode != 200) {
        throw ServerException(
            'Failed to sign up. Status code: ${res.statusCode}');
      }

      Map<String, dynamic> resBody = json.decode(res.body);
      return UserModel.fromJson(resBody);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      // Get the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      // If the token is null, set an empty string as token
      if (token == null) {
        prefs.setString("x-auth-token", "");
        token = "";
      }

      // Check token validity
      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      var tokenResponse = jsonDecode(tokenRes.body);

      // If the token is valid, fetch user data
      if (tokenResponse == true) {
        http.Response userRes = await http.get(
          Uri.parse("$uri/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        if (userRes.statusCode != 200) {
          throw ServerException(
              'Failed to fetch user data. Status code: ${userRes.statusCode}');
        }

        Map<String, dynamic> resBody = json.decode(userRes.body);
        return UserModel.fromJson(resBody);
      }

      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  void logOutUser(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
    } catch (e) {
      // Handle any exceptions here
      print('Error during logout: $e');
      // You can choose to handle the error silently or rethrow it as ServerException
      throw ServerException('Error during logout: $e');
    }
  }
}
