import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:money_track/core/common/widgets/custom_dialog.dart';
import 'package:money_track/core/common/widgets/reports_generator.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/format_date.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/features/expenses/presentation/widgets/calculation_functions.dart';
import 'package:money_track/features/expenses/presentation/widgets/expense_tile.dart';
import 'package:open_file_safe/open_file_safe.dart';

class ExpensesAnalysisDisplays extends StatelessWidget {
  final List<Expense> allExpenses;
  final String timeWise;
  final Function(BuildContext, String, String) showDeleteDialog;
  final Function(BuildContext, Expense) showEditBottomSheet;

  const ExpensesAnalysisDisplays({
    Key? key,
    required this.allExpenses,
    required this.timeWise,
    required this.showDeleteDialog,
    required this.showEditBottomSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reportGenerator = ReportGenerator();
    void _showCustomDialog(BuildContext context, VoidCallback onView) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: 'Reports ready',
            content: 'Your reports are ready to view.',
            onView: onView,
          );
        },
      );
    }

    if (allExpenses.isEmpty) {
      return const Text(
        'No expenses today!',
      );
    } else {
      final reportGenerator = ReportGenerator();
      return Expanded(
        child: Scaffold(
          body: ListView.separated(
            itemCount: allExpenses.length,
            itemBuilder: (context, index) {
              final expense = allExpenses[index];
              return Stack(
                children: [
                  if (expense.isEdited)
                    const Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        backgroundColor: AppPallete.errorColor,
                        radius: 10,
                        child: Text(
                          'E',
                          style: TextStyle(
                            fontSize: 8,
                            color: AppPallete.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  Dismissible(
                    key: Key(expense.id!),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      showDeleteDialog(context, expense.id!, expense.name);
                    },
                    child: GestureDetector(
                      onTap: () => showEditBottomSheet(context, expense),
                      child: ExpenseTile(
                        icon: CalculationFunctions.decideIcon(expense.category),
                        title: expense.name,
                        subtitle: expense.category,
                        amount: expense.amount,
                        date: formatDatedMMMYYYY(expense.date),
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: SpeedDial(
              icon: Icons.select_all_sharp,
              gradientBoxShape: BoxShape.circle,
              elevation: 2.0,
              tooltip: "Download",
              backgroundColor: AppPallete.boxColor,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.green, Colors.blue],
              ),
              //closeManually: true,
              curve: Curves.easeIn,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: 'PDF',
                  backgroundColor: Colors.blue.shade800,
                  labelBackgroundColor: Colors.blue.shade800,
                  labelStyle: const TextStyle(color: Colors.white),
                  onTap: () async {
                    _showCustomDialog(context, () async {
                      final pdf = await reportGenerator.createPDF(
                        allExpenses,
                        'Reports',
                        '',
                        '',
                        '',
                        timeWise,
                      );
                      final filePath = await reportGenerator.savePDF(pdf);
                      OpenFile.open(filePath);
                    });
                  },
                ),
                SpeedDialChild(
                  child: const Icon(
                    Icons.table_chart,
                    color: Colors.white,
                  ),
                  label: 'Excel',
                  backgroundColor: Colors.green,
                  labelBackgroundColor: Colors.green,
                  labelStyle: const TextStyle(color: Colors.white),
                  onTap: () async {
                    _showCustomDialog(context, () async {
                      await reportGenerator.createAndSaveExcel(
                        allExpenses,
                        'Reports',
                        '',
                        '',
                        '',
                        timeWise,
                      );
                    });
                  },
                ),
              ],
              child: const Icon(Icons.download),
            ),
          ),
        ),
      );
    }
  }
}
