import 'dart:convert';

import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/error/exception.dart';
import 'package:money_track/features/expenses/data/models/expense_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class ExpenseRemoteDataSource {
  Future<ExpenseModel> addExpense(ExpenseModel expense);
  Future<List<ExpenseModel>> getAllExpenses();
}

class ExpenseRemoteDataSourceImplement implements ExpenseRemoteDataSource {
  @override
  Future<ExpenseModel> addExpense(ExpenseModel expense) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }

      final response = await http.post(
        Uri.parse('$uri/user/add-expense'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: expense.toJson(),
      );

      if (response.statusCode != 200) {
        throw ServerException(
            'Failed to add expense. Status code: ${response.statusCode}');
      }

      final Map<String, dynamic> responseBody = json.decode(response.body);

      return ExpenseModel.fromMap(responseBody);
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ExpenseModel>> getAllExpenses() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null || token.isEmpty) {
        throw ServerException("User is not authenticated");
      }

      final response = await http.get(
        Uri.parse('$uri/user/get-expenses'),
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
          .map((expense) =>
              ExpenseModel.fromMap(expense as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }
}
