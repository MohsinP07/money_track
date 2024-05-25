part of 'app_user_cubit.dart';

@immutable
class AppUserState {}

class AppUserInitial extends AppUserState {}

class AppUserLoggedIn extends AppUserState {
  final User user;
  AppUserLoggedIn(this.user);
}
