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
            child: const Text('Close'),
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
      weeklyAnalysisText =
          'This week\'s total expense is $weeklyExpense ₹. The new week starts tomorrow!';
    } else {
      final daysRemainingInWeek = 7 - weekday;
      weeklyAnalysisText =
          'In the last ${7 - daysRemainingInWeek} days, you have spent $weeklyExpense ₹. You have $daysRemainingInWeek days left in this week.';
    }

    if (dayOfMonth == daysInMonth) {
      monthlyAnalysisText =
          'This month\'s total expense is $monthlyExpense ₹. A new month starts tomorrow!';
    } else {
      final daysRemainingInMonth = daysInMonth - dayOfMonth;
      monthlyAnalysisText =
          'So far this month, you have spent $monthlyExpense ₹. You have $daysRemainingInMonth days left in this month.';
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
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: InkWell(
                  onTap: () {
                    showAnalysisDialog(context, 'Weekly Expenses Analysis',
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
              const TextSpan(
                text: "Monthly Expenses\n",
                style: TextStyle(
                  color: AppPallete.whiteColor,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: InkWell(
                  onTap: () {
                    showAnalysisDialog(context, 'Monthly Expenses Analysis',
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
