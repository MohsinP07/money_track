// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/error/failures.dart';
import 'package:money_track/features/auth/domain/repository/auth_repository.dart';

class EditProfile {
  final AuthRepository repository;

  EditProfile(this.repository);

  Future<Either<Failure, User>> call(EditProfileParams params) async {
    return await repository.editProfile(
      name: params.name,
      phone: params.phone,
    );
  }
}

class EditProfileParams {
  final String name;
  final String phone;

  EditProfileParams({
    required this.name,
    required this.phone,
  });
}
