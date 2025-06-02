import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neopop/neopop.dart';
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
      monthlyAnalysisText = 'in_this_month_faar1'.tr +
          monthlyExpense.toString() +
          'in_this_month_faar2'.tr +
          daysRemainingInMonth.toString() +
          'in_this_month_faar3'.tr;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        height: height,
        width: width,
        child: NeoPopCard(
          color: AppPallete.boxColor,
          depth: 8,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.amber.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.credit_card,
                        color: Colors.white70, size: 24),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "****  ****  ****  1234",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    letterSpacing: 2.0,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Today's Expense
                      Expanded(
                        child: _ExpenseItem(
                          label: "todays_expenses".tr,
                          value: "${todaysExpense.toStringAsFixed(2)} ₹",
                          icon: null,
                          onTap: null,
                        ),
                      ),
                      // Weekly Expense
                      Expanded(
                        child: _ExpenseItem(
                          label: "weekly_expenses".tr,
                          value: "${weeklyExpense.toStringAsFixed(2)} ₹",
                          icon: Icons.info_outline,
                          onTap: () {
                            showAnalysisDialog(
                              context,
                              'weekly_expenses_analysis'.tr,
                              weeklyAnalysisText,
                            );
                          },
                        ),
                      ),
                      // Monthly Expense
                      Expanded(
                        child: _ExpenseItem(
                          label: "monthly_expenses".tr,
                          value: "${monthlyExpense.toStringAsFixed(2)} ₹",
                          icon: Icons.info_outline,
                          onTap: () {
                            showAnalysisDialog(
                              context,
                              'monthly_expenses_analysis'.tr,
                              monthlyAnalysisText,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Expense Card",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final VoidCallback? onTap;

  const _ExpenseItem({
    required this.label,
    required this.value,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 3),
              GestureDetector(
                onTap: onTap,
                child: Icon(icon, color: Colors.white70, size: 13),
              ),
            ],
          ],
        ),
      ],
    );
    return onTap != null ? InkWell(onTap: onTap, child: content) : content;
  }
}
