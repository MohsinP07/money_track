import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/usecases/use_case.dart';
import 'package:money_track/features/auth/domain/usecases/current_user.dart';
import 'package:money_track/features/auth/domain/usecases/log_out_user.dart';
import 'package:money_track/features/auth/domain/usecases/user_log_in.dart';
import 'package:money_track/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final UserLogout _userLogout;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required UserLogout userLogout,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _userLogout = userLogout,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthLogout>(_onAuthLogout);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(
        failure.message,
      )),
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
        emit(AuthSuccess(user));
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
        (failure) => emit(AuthFailure(
              failure.message,
            )),
        (user) => _emitAuthSuccess(user, emit));
  }

  void _onAuthLogout(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userLogout.call(event.context);

    res.fold(
      (failure) => emit(AuthFailure(
        failure.message,
      )),
      (_) {
        _appUserCubit.clearUser();
        emit(AuthInitial());
      },
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
