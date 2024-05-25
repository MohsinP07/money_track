import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/entity/user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial()); // logged off state
    } else {
      emit(AppUserLoggedIn(user));
    }
  }

  void clearUser() {
    emit(AppUserInitial()); // Clear user state
  }
}
