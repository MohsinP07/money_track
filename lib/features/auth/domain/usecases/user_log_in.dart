// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/core/usecases/use_case.dart';
import 'package:money_track/features/auth/domain/repository/auth_repository.dart';

class UserLogin extends UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;
  UserLogin(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;
  UserLoginParams({
    required this.email,
    required this.password,
  });
}
