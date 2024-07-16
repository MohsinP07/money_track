import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> editProfile({
    required String name,
    required String phone,
  });

  Future<Either<Failure, User>> currentUser();

  Future<Either<Failure, void>> deleteAllUserExpenses({
    required String expenserId,
  });

  void logoutUser({required BuildContext context});

  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String newPassword,
  });
}
