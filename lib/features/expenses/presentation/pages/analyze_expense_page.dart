import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/common/widgets/loader.dart';
import 'package:money_track/core/constants/constants.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/format_date.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:money_track/features/expenses/presentation/widgets/calculation_functions.dart';
import 'package:money_track/features/expenses/presentation/widgets/expense_analysis_displays.dart';
import 'package:money_track/features/expenses/presentation/widgets/edit_bottom_sheet.dart';

class AnalyzeExpensePage extends StatefulWidget {
  const AnalyzeExpensePage({super.key});

  @override
  State<AnalyzeExpensePage> createState() => _AnalyzeExpensePageState();
}

class _AnalyzeExpensePageState extends State<AnalyzeExpensePage> {
  String _selectedAnalysis = 'Today';
  String _selectedCategory = '';

  List<Expense> _filterTodayExpenses(List<Expense> expenses) {
    final today = DateTime.now();
    final filteredExpenses = expenses.where((expense) {
      final expenseDate = expense.date;
      return expenseDate.year == today.year &&
          expenseDate.month == today.month &&
          expenseDate.day == today.day;
    }).toList();

    // Sort the expenses by date in descending order
    filteredExpenses.sort((a, b) => b.date.compareTo(a.date));

    return filteredExpenses;
  }

  List<Expense> _filterWeeklyExpenses(List<Expense> expenses) {
    final today = DateTime.now();
    final startOfWeek = today.subtract(
        Duration(days: today.weekday - 1)); // Start of the week (Monday)
    final endOfWeek =
        startOfWeek.add(Duration(days: 6)); // End of the week (Sunday)

    final filteredExpenses = expenses.where((expense) {
      final expenseDate = expense.date;
      return expenseDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
          expenseDate.isBefore(endOfWeek.add(Duration(days: 1)));
    }).toList();

    // Sort the expenses by date in descending order
    filteredExpenses.sort((a, b) => b.date.compareTo(a.date));

    return filteredExpenses;
  }

  List<Expense> _filterOneMonthExpenses(List<Expense> expenses) {
    final today = DateTime.now();
    final startOfMonth = DateTime(today.year, today.month, 1);
    final endOfMonth = DateTime(today.year, today.month + 1, 0);

    final filteredExpenses = expenses.where((expense) {
      final expenseDate = expense.date;
      return expenseDate.isAfter(startOfMonth.subtract(Duration(days: 1))) &&
          expenseDate.isBefore(endOfMonth.add(Duration(days: 1)));
    }).toList();

    // Sort the expenses by date in descending order
    filteredExpenses.sort((a, b) => b.date.compareTo(a.date));

    return filteredExpenses;
  }

  void _showDeleteDialog(
      BuildContext context, String expenseId, String expenseName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text('Are you sure you want to delete $expenseName expense?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ExpensesBloc>().add(ExpenseGetAllExpenses());
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppPallete.boxColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ExpensesBloc>().add(ExpenseDelete(id: expenseId));
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppPallete.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context, Expense expense) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) => EditExpenseBottomSheet(expense: expense),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    final userName =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.name;
    return Scaffold(
      body: BlocConsumer<ExpensesBloc, ExpensesState>(
        listener: (context, state) {
          if (state is ExpensesFailure) {
            showSnackBar(context, state.error);
          }
          if (state is DeleteExpensesSuccess) {
            showSnackBar(context, 'Deleted expense successfully!!');
            context.read<ExpensesBloc>().add(ExpenseGetAllExpenses());
          }
          if (state is EditExpensesSuccess) {
            showSnackBar(context, 'Edited expense successfully!!');
            context.read<ExpensesBloc>().add(ExpenseGetAllExpenses());
          }
        },
        builder: (context, state) {
          if (state is ExpensesLoading) {
            return const Loader();
          }
          if (state is ExpensesDisplaySuccess) {
            final todayExpenses = _filterTodayExpenses(state.expenses);
            final weeklyExpenses = _filterWeeklyExpenses(state.expenses);
            final monhlyExpenses = _filterOneMonthExpenses(state.expenses);

            return SafeArea(
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
                          text: "Analyze ",
                          style: TextStyle(
                            color: AppPallete.blackColor,
                            fontSize: 30,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextSpan(
                          text: "Expenses",
                          style: TextStyle(
                            color: AppPallete.blackColor,
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: deviceSize(context).width * 0.044,
                      backgroundColor: AppPallete.boxColor,
                      child: Text(
                        userName.substring(0, 1),
                        style: const TextStyle(color: AppPallete.whiteColor),
                      ),
                    ),
                    title: Text(
                      "Good day, $userName",
                      style: const TextStyle(fontSize: 12),
                    ),
                    subtitle: const Text(
                      'Track your expenses, spend your day right',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: deviceSize(context).height * 0.01,
                  ),
                  const Text("Time wise"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: Constants.expenseAnalyzer
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedAnalysis = e;
                                  });
                                  print(_selectedAnalysis);
                                },
                                child: Chip(
                                  label: Text(
                                    e,
                                    style: TextStyle(
                                      color: _selectedAnalysis == e
                                          ? AppPallete.whiteColor
                                          : AppPallete.blackColor,
                                    ),
                                  ),
                                  side: _selectedAnalysis == e
                                      ? null
                                      : const BorderSide(
                                          color: AppPallete.borderColor,
                                        ),
                                  backgroundColor: _selectedAnalysis == e
                                      ? AppPallete.buttonColor
                                      : null,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  if (_selectedAnalysis == 'Today')
                    if (todayExpenses.isEmpty)
                      const Text(
                        'No expenses today!',
                      )
                    else
                      ExpensesAnalysisDisplays(
                        todayExpenses: todayExpenses,
                        showDeleteDialog: _showDeleteDialog,
                        showEditBottomSheet: _showEditBottomSheet,
                      ),
                  if (_selectedAnalysis == 'This week')
                    if (todayExpenses.isEmpty)
                      const Text(
                        'No expenses for week!',
                      )
                    else
                      ExpensesAnalysisDisplays(
                        todayExpenses: weeklyExpenses,
                        showDeleteDialog: _showDeleteDialog,
                        showEditBottomSheet: _showEditBottomSheet,
                      ),
                  if (_selectedAnalysis == 'This Month')
                    if (todayExpenses.isEmpty)
                      const Text(
                        'No expenses for month!',
                      )
                    else
                      ExpensesAnalysisDisplays(
                        todayExpenses: monhlyExpenses,
                        showDeleteDialog: _showDeleteDialog,
                        showEditBottomSheet: _showEditBottomSheet,
                      ),
                  if (_selectedAnalysis == 'Custom')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Category wise"),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: Constants.expenseCategory
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = e;
                                        });
                                        print(_selectedCategory);
                                      },
                                      child: Chip(
                                        label: Text(
                                          e,
                                          style: TextStyle(
                                            color: _selectedCategory == e
                                                ? AppPallete.whiteColor
                                                : AppPallete.blackColor,
                                          ),
                                        ),
                                        side: _selectedCategory == e
                                            ? null
                                            : const BorderSide(
                                                color: AppPallete.borderColor,
                                              ),
                                        backgroundColor: _selectedCategory == e
                                            ? AppPallete.buttonColor
                                            : null,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ));
          }
          return Container();
        },
      ),
    );
  }
}
