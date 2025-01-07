// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/auth/domain/repository/auth_repository.dart';
import 'package:money_track/core/entity/user.dart';

class GetAllUsers {
  final AuthRepository repository;

  GetAllUsers(this.repository);

  Future<Either<Failure, List<User>>> call() async {
    return await repository.getAllUsers();
  }
}
