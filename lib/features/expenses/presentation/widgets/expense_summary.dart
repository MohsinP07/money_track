// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  void showAnalysisDialog(
      BuildContext context, String title, String analysisText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(analysisText),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('close'.tr),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekday = now.weekday;
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final dayOfMonth = now.day;

    String weeklyAnalysisText;
    String monthlyAnalysisText;
    if (weekday == 7) {
      weeklyAnalysisText = 'the_weeks_total1'.tr +
          weeklyExpense.toString() +
          'the_weeks_total2'.tr;
    } else {
      final daysRemainingInWeek = 7 - weekday;
      weeklyAnalysisText = 'in_the_last1'.tr +
          (7 - daysRemainingInWeek).toString() +
          'in_the_last2'.tr +
          weeklyExpense.toString() +
          'in_the_last3'.tr +
          daysRemainingInWeek.toString() +
          'in_the_last4'.tr;
    }

    if (dayOfMonth == daysInMonth) {
      monthlyAnalysisText =
          'in_this_month1'.tr + monthlyExpense.toString() + 'in_this_month2'.tr;
    } else {
      final daysRemainingInMonth = daysInMonth - dayOfMonth;
      monthlyAnalysisText =
          'in_this_month_faar1'.tr + monthlyExpense.toString() + 'in_this_month_faar2'.tr + daysRemainingInMonth.toString() + 'in_this_month_faar3'.tr;
    }

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
          maxLines: 10,
          text: TextSpan(
            children: [
               TextSpan(
                text: "todays_expenses".tr,
                style:const TextStyle(
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
               TextSpan(
                text: "weekly_expenses".tr,
                style:const TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: InkWell(
                  onTap: () {
                    showAnalysisDialog(context, 'weekly_expenses_analysis'.tr,
                        weeklyAnalysisText);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${weeklyExpense.toString()} ₹',
                        style: const TextStyle(
                          color: AppPallete.whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Icon(Icons.info_outline, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
               TextSpan(
                text: "monthly_expenses".tr,
                style:const TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: InkWell(
                  onTap: () {
                    showAnalysisDialog(context, 'monthly_expenses_analysis'.tr,
                        monthlyAnalysisText);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${monthlyExpense.toString()} ₹',
                        style: const TextStyle(
                          color: AppPallete.whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Icon(Icons.info_outline, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
