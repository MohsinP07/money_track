import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
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

  Future<UserModel> editProfile({
    required String name,
    required String phone,
  });

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });

  Future<UserModel?> getCurrentUserData();

  Future<List<UserModel>?> getAllUsers();

  Future<void> deleteAllUserExpenses({required String expenserId});

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
        final Map<String, dynamic> errorResponse = json.decode(res.body);
        final String errorMessage = errorResponse['msg'] ??
            'Failed to log in. Status code: ${res.statusCode}';
        throw ServerException(errorMessage);
      }

      Map<String, dynamic> resBody = json.decode(res.body);

      // Store the token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('x-auth-token', resBody['token']);

      return UserModel.fromJson(resBody);
    } catch (e) {
      if (e is ServerException) {
        throw e; // Re-throw the same exception
      } else {
        throw ServerException(e.toString());
      }
    }
  }

  @override
  Future<UserModel> signUpEithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
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
        final Map<String, dynamic> errorResponse = json.decode(res.body);
        final String errorMessage = errorResponse['msg'] ??
            'Failed to sign up. Status code: ${res.statusCode}';
        throw ServerException(errorMessage);
      }

      Map<String, dynamic> resBody = json.decode(res.body);
      return UserModel.fromJson(resBody);
    } catch (e) {
      if (e is ServerException) {
        throw e; // Re-throw the same exception
      } else {
        throw ServerException(e.toString());
      }
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

        if (prefs.containsKey('language')) {
          List<String>? languageList = prefs.getStringList('language');
          if (languageList != null && languageList.isNotEmpty) {
            Get.updateLocale(Locale(languageList[0], languageList[1]));
          }
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

  Future<UserModel> editProfile({
    required String name,
    required String phone,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }
      if (name.isEmpty || phone.isEmpty) {
        throw ServerException("Name and phone cannot be empty");
      }

      final response = await http.put(
        Uri.parse('$uri/auth/updateProfile'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: json.encode({
          'name': name,
          'phone': phone,
        }),
      );

      if (response.statusCode != 200) {
        throw ServerException(
            'Failed to edit profile. Status code: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = json.decode(response.body);

      print('Response Body: $responseBody'); // Log the response body

      return UserModel.fromMap(responseBody);
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/auth/reset-password'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'email': email,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        final String errorMessage = errorResponse['msg'] ??
            'Failed to reset password. Status code: ${response.statusCode}';
        throw ServerException(errorMessage);
      }
    } catch (e) {
      if (e is ServerException) {
        throw e; // Re-throw the same exception
      } else {
        throw ServerException(e.toString());
      }
    }
  }

  @override
  Future<void> deleteAllUserExpenses({required String expenserId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }

      final response = await http.delete(
        Uri.parse('$uri/user/delete-all-expense'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: json.encode({
          'expenserId': expenserId,
        }),
      );

      if (response.statusCode != 200) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        final String errorMessage = errorResponse['msg'] ??
            'Failed to delete all expenses. Status code: ${response.statusCode}';
        throw ServerException(errorMessage);
      }
    } catch (e) {
      if (e is ServerException) {
        throw e; // Re-throw the same exception
      } else {
        throw ServerException(e.toString());
      }
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }
      final response = await http.get(
        Uri.parse('$uri/auth/get-all-users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      print('$uri/auth/get-all-users');
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((user) => UserModel.fromJson(user as Map<String, dynamic>))
            .toList();
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        final String errorMessage = errorResponse['msg'] ??
            'Failed to fetch all users. Status code: ${response.statusCode}';
        throw ServerException(errorMessage);
      }
    } catch (e) {
      throw ServerException("An unexpected error occurred: ${e.toString()}");
    }
  }
}
