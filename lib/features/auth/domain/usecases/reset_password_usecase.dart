// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/auth/domain/repository/auth_repository.dart';

class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await repository.resetPassword(
        email: params.email, newPassword: params.newPassword);
  }
}

class ResetPasswordParams {
  final String email;
  final String newPassword;

  ResetPasswordParams({
    required this.email,
    required this.newPassword,
  });
}
