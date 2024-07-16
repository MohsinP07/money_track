part of 'auth_bloc.dart';

@immutable
class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(
    this.user,
  );
}

class AuthProfileEditing extends AuthState {}

class AuthPasswordReseting extends AuthState {}

class AuthPasswordResetSuccess extends AuthState {}

class AuthDeleteAllExpense extends AuthState {}

class AuthDeleteAllExpenseSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
