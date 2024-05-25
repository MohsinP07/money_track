import 'package:get_it/get_it.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:money_track/features/auth/data/repositories/auth_repository_implement.dart';
import 'package:money_track/features/auth/domain/usecases/current_user.dart';
import 'package:money_track/features/auth/domain/usecases/log_out_user.dart';
import 'package:money_track/features/auth/domain/usecases/user_log_in.dart';
import 'package:money_track/features/auth/domain/usecases/user_sign_up.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:money_track/features/expenses/data/repositories/expense_repository_implement.dart';
import 'package:money_track/features/expenses/domain/repository/expense_repository.dart';
import 'package:money_track/features/expenses/domain/usecases/add_expense.dart';
import 'package:money_track/features/expenses/domain/usecases/get_all_expenses.dart';
import 'package:money_track/features/expenses/presentation/bloc/expenses_bloc.dart';

import 'features/auth/domain/repository/auth_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initExpense();
  //Core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
}

void _initAuth() {
  //Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImplement())
    //Repository
    ..registerFactory<AuthRepository>(() => AuthRepositoryImplement(
          serviceLocator(),
        ))
    //Usecases
    ..registerFactory(() => UserSignUp(
          serviceLocator(),
        ))
    ..registerFactory(() => UserLogin(
          serviceLocator(),
        ))
    ..registerFactory(() => CurrentUser(
          serviceLocator(),
        ))
    ..registerFactory(() => UserLogout(
          serviceLocator(),
        ))

    //Bloc
    ..registerLazySingleton(() => AuthBloc(
          userSignUp: serviceLocator(),
          userLogin: serviceLocator(),
          currentUser: serviceLocator(),
          appUserCubit: serviceLocator(),
          userLogout: serviceLocator(),
        ));
}

_initExpense() {
  //Datasource
  serviceLocator
    ..registerFactory<ExpenseRemoteDataSource>(
        () => ExpenseRemoteDataSourceImplement())

    //Repository
    ..registerFactory<ExpenseRepository>(() => ExpenseRepositoryImplement(
          serviceLocator(),
        ))

    //Usecases
    ..registerFactory(() => AddExpense(
          serviceLocator(),
        ))
    ..registerFactory(() => GetAllExpenses(
          serviceLocator(),
        ))

    //Bloc
    ..registerLazySingleton<ExpensesBloc>(() => ExpensesBloc(
          addExpense: serviceLocator(),
          getAllExpenses: serviceLocator(),
        ));
}
