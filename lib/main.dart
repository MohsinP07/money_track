import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/themes/theme.dart';
import 'package:money_track/core/utils/locale_strings.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/auth/presentation/pages/login_page.dart';
import 'package:money_track/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:money_track/features/expenses/presentation/widgets/bottom_bar.dart';
import 'package:money_track/features/onboarding/presentation/pages/landing_screen.dart';
import 'package:money_track/init_dependencies.dart';
import 'package:money_track/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<ExpensesBloc>(),
      )
    ], child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkLoggedInStatus();
    _setLocaleFromPreferences();
  }

  Future<void> _checkLoggedInStatus() async {
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  Future<void> _setLocaleFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('language')) {
      List<String>? languageList = prefs.getStringList('language');
      if (languageList != null && languageList.isNotEmpty) {
        Get.updateLocale(Locale(languageList[0], languageList[1]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Money Track App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeMode,
      locale: Locale("en", "US"),
      translations: LocaleString(),
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BottomBar(
              initialPage: 0,
            );
          }
          return LandingPage();
        },
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
