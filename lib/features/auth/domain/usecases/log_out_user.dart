import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/core/usecases/use_case.dart';
import 'package:money_track/features/auth/domain/repository/auth_repository.dart';

class UserLogout implements UseCase<void, BuildContext> {
  final AuthRepository repository;

  UserLogout(this.repository);

  @override
  Future<Either<Failure, void>> call(BuildContext context) async {
    try {
      repository.logoutUser(context: context);
      return right(null);
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
