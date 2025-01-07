import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/error/exception.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:money_track/features/auth/data/models/usermodel.dart';
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

  @override
  Future<Either<Failure, User>> editProfile({
    required String name,
    required String phone,
  }) async {
    try {
      // Check if name and phone are not null or empty
      if (name.isEmpty || phone.isEmpty) {
        return left(Failure("Name and phone cannot be empty"));
      }

      final editProfile = await remoteDataSource.editProfile(
        name: name,
        phone: phone,
      );
      return right(editProfile);
    } on ServerException catch (e) {
      print(e);
      throw Failure(e.message);
    }
  }

  @override
  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
          email: email, newPassword: newPassword);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllUserExpenses({
    required String expenserId,
  }) async {
    try {
      await remoteDataSource.deleteAllUserExpenses(
        expenserId: expenserId,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      // Call the remote data source to fetch users
      final List<UserModel> userModels =
          await remoteDataSource.getAllUsers() ?? [];

      if (userModels.isEmpty) {
        return const Right([]); // Return an empty list if no users are found
      }

      // Map UserModel list to List<User>
      final List<User> users = userModels
          .map((userModel) => User(
                id: userModel.id,
                name: userModel.name,
                email: userModel.email,
                phone: userModel.phone,
              ))
          .toList();

      return Right(users);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
