import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/create_finance_goals.dart';

class AllFinanceGoals extends StatefulWidget {
  static const String routeName = "all-financial-goals-screen";
  const AllFinanceGoals({super.key});

  @override
  State<AllFinanceGoals> createState() => _AllFinanceGoalsState();
}

class _AllFinanceGoalsState extends State<AllFinanceGoals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(10.0).copyWith(top: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RichText(
                maxLines: 2,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "All Fincance".tr,
                      style: const TextStyle(
                        color: AppPallete.blackColor,
                        fontSize: 30,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextSpan(
                      text: "Goals".tr,
                      style: const TextStyle(
                        color: AppPallete.blackColor,
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const Text("No goals created")
            ])),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppPallete.buttonColor,
          child: const Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(CreateFinanceGoals.routeName);
          }),
    );
  }
}
