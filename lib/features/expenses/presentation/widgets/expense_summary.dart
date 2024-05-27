import 'package:flutter/material.dart';
import 'package:money_track/core/themes/app_pallete.dart';

class ExpenseSummaryContainer extends StatelessWidget {
  final double height;
  final double width;
  final double todaysExpense;
  final double weeklyExpense;
  final double monthlyExpense;

  const ExpenseSummaryContainer({
    Key? key,
    required this.height,
    required this.width,
    required this.todaysExpense,
    required this.weeklyExpense,
    required this.monthlyExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPallete.boxColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: RichText(
          maxLines: 6,
          text: TextSpan(
            children: [
              const TextSpan(
                text: "Today's Expenses\n",
                style: TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              TextSpan(
                text: '${todaysExpense.toString()} ₹\n',
                style: const TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const TextSpan(
                text: "Weekly Expenses\n",
                style: TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              const WidgetSpan(
                child: SizedBox(height: 8),
              ),
              TextSpan(
                text: '${weeklyExpense.toString()} ₹\n',
                style: const TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const TextSpan(
                text: "Monthly Expenses\n",
                style: TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              const WidgetSpan(
                child: SizedBox(height: 8),
              ),
              TextSpan(
                text: '${monthlyExpense.toString()} ₹',
                style: const TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
