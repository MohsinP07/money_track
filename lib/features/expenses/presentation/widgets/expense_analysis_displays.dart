import 'package:flutter/material.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/format_date.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/features/expenses/presentation/widgets/calculation_functions.dart';
import 'package:money_track/features/expenses/presentation/widgets/expense_tile.dart';

class ExpensesAnalysisDisplays extends StatelessWidget {
  final List<Expense> todayExpenses;
  final Function(BuildContext, String, String) showDeleteDialog;
  final Function(BuildContext, Expense) showEditBottomSheet;

  const ExpensesAnalysisDisplays({
    Key? key,
    required this.todayExpenses,
    required this.showDeleteDialog,
    required this.showEditBottomSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (todayExpenses.isEmpty) {
      return const Text(
        'No expenses today!',
      );
    } else {
      return Expanded(
        child: ListView.separated(
          itemCount: todayExpenses.length,
          itemBuilder: (context, index) {
            final expense = todayExpenses[index];
            return Stack(children: [
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
            ]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      );
    }
  }
}
