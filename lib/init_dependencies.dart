import 'package:get_it/get_it.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:money_track/features/auth/data/repositories/auth_repository_implement.dart';
import 'package:money_track/features/auth/domain/usecases/current_user.dart';
import 'package:money_track/features/auth/domain/usecases/delete_all_expenses.dart';
import 'package:money_track/features/auth/domain/usecases/edit_profile.dart';
import 'package:money_track/features/auth/domain/usecases/get_all_users.dart';
import 'package:money_track/features/auth/domain/usecases/log_out_user.dart';
import 'package:money_track/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:money_track/features/auth/domain/usecases/user_log_in.dart';
import 'package:money_track/features/auth/domain/usecases/user_sign_up.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:money_track/features/expenses/data/repositories/expense_repository_implement.dart';
import 'package:money_track/features/expenses/domain/repository/expense_repository.dart';
import 'package:money_track/features/expenses/domain/usecases/add_expense.dart';
import 'package:money_track/features/expenses/domain/usecases/delete_expense.dart';
import 'package:money_track/features/expenses/domain/usecases/edit_expense.dart';
import 'package:money_track/features/expenses/domain/usecases/get_all_expenses.dart';
import 'package:money_track/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:money_track/features/group/data/datasources/group_remote_data_source.dart';
import 'package:money_track/features/group/data/repositories/group_repository_implement.dart';
import 'package:money_track/features/group/domain/repository/group_repository.dart';
import 'package:money_track/features/group/domain/usecases/add_group_expenses.dart';
import 'package:money_track/features/group/domain/usecases/create_group.dart';
import 'package:money_track/features/group/domain/usecases/delete_group.dart';
import 'package:money_track/features/group/domain/usecases/edit_group.dart';
import 'package:money_track/features/group/domain/usecases/get_all_groups.dart';
import 'package:money_track/features/group/domain/usecases/get_group_expenses.dart';
import 'package:money_track/features/group/presentation/bloc/bloc/group_bloc.dart';

import 'features/auth/domain/repository/auth_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initExpense();
  _initGroup();
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
    ..registerFactory(() => EditProfile(
          serviceLocator(),
        ))
    ..registerFactory(() => CurrentUser(
          serviceLocator(),
        ))
    ..registerFactory(() => UserLogout(
          serviceLocator(),
        ))
    ..registerFactory(() => ResetPassword(
          serviceLocator(),
        ))
    ..registerFactory(() => DeleteAllExpenses(
          serviceLocator(),
        ))
    ..registerFactory(() => GetAllUsers(
          serviceLocator(),
        ))

    //Bloc
    ..registerLazySingleton(() => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        editProfile: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
        userLogout: serviceLocator(),
        resetPassword: serviceLocator(),
        deleteAllExpenses: serviceLocator(),
        getAllUsers: serviceLocator()));
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
    ..registerFactory(() => DeleteExpense(
          serviceLocator(),
        ))
    ..registerFactory(() => EditExpense(
          serviceLocator(),
        ))

    //Bloc
    ..registerLazySingleton<ExpensesBloc>(() => ExpensesBloc(
          addExpense: serviceLocator(),
          getAllExpenses: serviceLocator(),
          deleteExpense: serviceLocator(),
          editExpense: serviceLocator(),
        ));
}

_initGroup() {
  //Datasource
  serviceLocator
    ..registerFactory<GroupRemoteDataSource>(
        () => GroupRemoteDataSourceImplement())

    //Repository
    ..registerFactory<GroupRepository>(() => GroupRepositoryImplement(
          serviceLocator(),
        ))

    //Usecases
    ..registerFactory(() => CreateGroup(
          serviceLocator(),
        ))
    ..registerFactory(() => GetAllGroups(
          serviceLocator(),
        ))
    ..registerFactory(() => EditGroup(
          serviceLocator(),
        ))
    ..registerFactory(() => DeleteGroup(
          serviceLocator(),
        ))
    ..registerFactory(() => AddGroupExpenses(
          serviceLocator(),
        ))
    ..registerFactory(() => GetGroupExpenses(
          serviceLocator(),
        ))

    //Bloc
    ..registerLazySingleton<GroupBloc>(() => GroupBloc(
          addExpense: serviceLocator(),
          getAllGroups: serviceLocator(),
          editGroup: serviceLocator(),
          deleteGroup: serviceLocator(),
          addGroupExpenses: serviceLocator(),
          getGroupExpenses: serviceLocator(),
        ));
}
