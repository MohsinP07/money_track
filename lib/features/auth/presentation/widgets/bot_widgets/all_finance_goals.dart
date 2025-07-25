import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/create_finance_goals.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/widgets/finance_goal_list.dart';

class AllFinanceGoals extends StatelessWidget {
  static const String routeName = "all-financial-goals-screen";
  const AllFinanceGoals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId =
        (context.watch<AppUserCubit>().state as AppUserLoggedIn).user.id;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0).copyWith(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                maxLines: 2,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "All Finance ",
                      style: TextStyle(
                          color: AppPallete.blackColor,
                          fontSize: 30,
                          fontFamily: 'Poppins'),
                    ),
                    TextSpan(
                      text: "Goals",
                      style: TextStyle(
                          color: AppPallete.blackColor,
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: FinanceGoalList(userId: userId)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppPallete.buttonColor,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            CreateFinanceGoalsScreen.routeName,
          );
        },
      ),
    );
  }
}
