import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/usecases/use_case.dart';
import 'package:money_track/features/auth/domain/usecases/current_user.dart';
import 'package:money_track/features/auth/domain/usecases/edit_profile.dart';
import 'package:money_track/features/auth/domain/usecases/log_out_user.dart';
import 'package:money_track/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:money_track/features/auth/domain/usecases/user_log_in.dart';
import 'package:money_track/features/auth/domain/usecases/user_sign_up.dart';
import 'package:money_track/features/auth/domain/usecases/delete_all_expenses.dart';
import 'package:money_track/features/auth/domain/usecases/get_all_users.dart'; // Add the GetAllUsers use case

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final EditProfile _editProfile;
  final CurrentUser _currentUser;
  final UserLogout _userLogout;
  final ResetPassword _resetPassword;
  final DeleteAllExpenses _deleteAllExpenses;
  final GetAllUsers _getAllUsers; // Add GetAllUsers use case
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required EditProfile editProfile,
    required CurrentUser currentUser,
    required UserLogout userLogout,
    required ResetPassword resetPassword,
    required DeleteAllExpenses deleteAllExpenses,
    required GetAllUsers getAllUsers, // Add GetAllUsers
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _editProfile = editProfile,
        _currentUser = currentUser,
        _userLogout = userLogout,
        _resetPassword = resetPassword,
        _deleteAllExpenses = deleteAllExpenses,
        _getAllUsers = getAllUsers, // Initialize GetAllUsers
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthEditProfile>(_onEditProfile);
    on<AuthLogout>(_onAuthLogout);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthResetPassword>(_onAuthResetPassword);
    on<AuthDeleteAllExpenses>(_onAuthDeleteAllExpenses);
    on<AuthGetAllUsers>(_onAuthGetAllUsers); // Handle the AuthGetAllUsers event
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp.call(UserSignUpParams(
      name: event.name,
      email: event.email,
      password: event.password,
    ));
    res.fold(
      (failure) {
        print('Failure: ${failure.message}');
        emit(AuthFailure(failure.message));
      },
      (user) {
        print('User: ${user.name}');
        _emitAuthSuccess(user, emit);
      },
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin.call(UserLoginParams(
      email: event.email,
      password: event.password,
    ));
    print(res);
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onEditProfile(AuthEditProfile event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _editProfile(EditProfileParams(
      name: event.name,
      phone: event.phone,
    ));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (editedProfile) {
        _appUserCubit.updateUser(editedProfile);
        emit(AuthSuccess(editedProfile));
      },
    );
  }

  void _onAuthLogout(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userLogout.call(event.context);

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) {
        _appUserCubit.clearUser();
        emit(AuthInitial());
      },
    );
  }

  void _onAuthResetPassword(
    AuthResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthPasswordReseting());
    final result = await _resetPassword.call(ResetPasswordParams(
      email: event.email,
      newPassword: event.newPassword,
    ));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthPasswordResetSuccess()),
    );
  }

  void _onAuthDeleteAllExpenses(
    AuthDeleteAllExpenses event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _deleteAllExpenses(DeleteAllExpensesParams(
      expenserId: event.expenserId,
    ));
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthDeleteAllExpenseSuccess()),
    );
  }

  // Handle fetching all users
  void _onAuthGetAllUsers(
    AuthGetAllUsers event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _getAllUsers();

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (users) => emit(AuthGetAllUsersSuccess(users)),
    );
  }

  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
