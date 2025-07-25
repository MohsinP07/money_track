import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/modals/goal_modal.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/modals/travel_goal_moddal.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/modals/wedding_goal_modal.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/goal_box.dart';

class CreateFinanceGoalsScreen extends StatelessWidget {
  static const routeName = 'create-finance-goals-screen';
  const CreateFinanceGoalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
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
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Finance",
                      style: TextStyle(
                          color: AppPallete.blackColor,
                          fontSize: 30,
                          fontFamily: 'Poppins'),
                    ),
                    TextSpan(
                      text: " Goals",
                      style: TextStyle(
                          color: AppPallete.blackColor,
                          fontSize: 34,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 16,
                  children: [
                    GoalBox(
                      deviceSize: deviceSize,
                      title: "Bike Goal",
                      image: 'assets/images/bike.png',
                      onPressed: () => showGoalModal(context, 'Bike', userId),
                    ),
                    GoalBox(
                      deviceSize: deviceSize,
                      title: "Car Goal",
                      image: 'assets/images/car.png',
                      onPressed: () => showGoalModal(context, 'Car', userId),
                    ),
                    GoalBox(
                      deviceSize: deviceSize,
                      title: "House Goal",
                      image: 'assets/images/home.png',
                      onPressed: () => showGoalModal(context, 'House', userId),
                    ),
                    GoalBox(
                      deviceSize: deviceSize,
                      title: "Wedding Goal",
                      image: 'assets/images/wedding.png',
                      onPressed: () => showWeddingGoalModal(context, userId),
                    ),
                    GoalBox(
                      deviceSize: deviceSize,
                      title: "Travel Goal",
                      image: 'assets/images/travel.png',
                      onPressed: () => showTravelGoalModal(context, userId),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
