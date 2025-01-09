import 'package:flutter/material.dart';
import 'package:money_track/features/auth/presentation/pages/login_page.dart';
import 'package:money_track/features/auth/presentation/pages/profile_page.dart';
import 'package:money_track/features/auth/presentation/pages/signup_page.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/all_finance_goals.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/create_finance_goals.dart';
import 'package:money_track/features/auth/presentation/widgets/money_bot_ai.dart';
import 'package:money_track/features/group/presentation/widgets/add_group_page.dart';
import 'package:money_track/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:money_track/features/settings/presentation/pages/settings_page.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginPage.routename:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const LoginPage());
    case SignUpPage.routename:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const SignUpPage());
    case ProfilePage.routename:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const ProfilePage());
    case SettingsPage.routename:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const SettingsPage());
    case MoneyBotAI.routename:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const MoneyBotAI());
    case Onboarding.routename:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => Onboarding());
    case CreateFinanceGoals.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => CreateFinanceGoals());
    case AllFinanceGoals.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => AllFinanceGoals());
    case AddGroupPage.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => AddGroupPage());
    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Scaffold(
                body: Center(
                  child: Text("Screen does not exist!"),
                ),
              ));
  }
}
