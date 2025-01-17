part of 'auth_bloc.dart';

@immutable
class AuthEvent {}

class AuthSignUp extends AuthEvent {
  final String email;
  final String name;
  final String password;
  AuthSignUp({
    required this.email,
    required this.name,
    required this.password,
  });
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;
  AuthLogin({
    required this.email,
    required this.password,
  });
}

class AuthEditProfile extends AuthEvent {
  final String name;
  final String phone;

  AuthEditProfile({
    required this.name,
    required this.phone,
  });
}

class AuthResetPassword extends AuthEvent {
  final String email;
  final String newPassword;

  AuthResetPassword({
    required this.email,
    required this.newPassword,
  });
}

class AuthIsUserLoggedIn extends AuthEvent {}

class AuthLogout extends AuthEvent {
  final BuildContext context;

  AuthLogout({required this.context});
}

class AuthDeleteAllExpenses extends AuthEvent {
  final String expenserId;

  AuthDeleteAllExpenses({
    required this.expenserId,
  });
}

class AuthGetAllUsers extends AuthEvent {}
