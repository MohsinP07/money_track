import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/error/exception.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:money_track/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/error/failures.dart';

class AuthRepositoryImplement implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImplement(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure("User not logged in!"));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword(
      {required String email, required String password}) {
    return _getUser(
        () async => await remoteDataSource.loginWithEmailAndPassword(
              email: email,
              password: password,
            ));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword(
      {required String name, required String email, required String password}) {
    //wrapper function
    return _getUser(
        () async => await remoteDataSource.signUpEithEmailAndPassword(
              name: name,
              email: email,
              password: password,
            ));
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();

      return right(user); //Means it is a success using Fpdart package.
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  void logoutUser({required BuildContext context}) {
    try {
      remoteDataSource.logOutUser(context);
    } on ServerException catch (e) {
      throw Failure(e.message);
    }
  }
}
