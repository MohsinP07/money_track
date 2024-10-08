// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/common/widgets/loader.dart';
import 'package:money_track/core/constants/constants.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:money_track/features/expenses/presentation/widgets/custom_analysis_display.dart';
import 'package:money_track/features/expenses/presentation/widgets/expense_analysis_displays.dart';
import 'package:money_track/features/expenses/presentation/widgets/edit_bottom_sheet.dart';

enum AnalysisType { timeWise, custom }

class AnalyzeExpensePage extends StatefulWidget {
  const AnalyzeExpensePage({super.key});

  @override
  State<AnalyzeExpensePage> createState() => _AnalyzeExpensePageState();
}

class _AnalyzeExpensePageState extends State<AnalyzeExpensePage> {
  String _selectedAnalysis = 'today'.tr;
  String _selectedCategory = 'all'.tr;
  bool _showCustomExpenses = false;
  var _analysisType = AnalysisType.timeWise;

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

  List<Expense> _filterExpensesByCategory(
      List<Expense> expenses, String category) {
    if (category == 'all'.tr) {
      return expenses;
    }

    final filteredExpenses = expenses.where((expense) {
      return expense.category == category;
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
        title: Text('delete_expense'.tr),
        content: Text('are_you_sure_delete1'.tr +
            expenseName.toString() +
            'are_you_sure_delete2'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ExpensesBloc>().add(ExpenseGetAllExpenses());
            },
            child: Text(
              'cancel'.tr,
              style: const TextStyle(color: AppPallete.boxColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ExpensesBloc>().add(ExpenseDelete(id: expenseId));
            },
            child: Text(
              'delete'.tr,
              style: const TextStyle(color: AppPallete.errorColor),
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
            showSnackBar(context, 'deleted_expense_success'.tr);
            context.read<ExpensesBloc>().add(ExpenseGetAllExpenses());
          }
          if (state is EditExpensesSuccess) {
            showSnackBar(context, 'edited_expense_success'.tr);
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
            final categoryWiseExpenses =
                _filterExpensesByCategory(state.expenses, _selectedCategory);

            return SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(10.0).copyWith(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: 2,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "analyze".tr,
                          style: const TextStyle(
                            color: AppPallete.blackColor,
                            fontSize: 30,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextSpan(
                          text: "expensesa".tr,
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
                      "good_day".tr + "$userName",
                      style: const TextStyle(fontSize: 12),
                    ),
                    subtitle: Text(
                      'track_your_expenses'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: deviceSize(context).height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12)),
                        child: ChoiceChip(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "time_wise".tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _analysisType == AnalysisType.timeWise
                                    ? AppPallete.whiteColor
                                    : AppPallete.boxColor,
                              ),
                            ),
                          ),
                          selected: _analysisType == AnalysisType.timeWise,
                          onSelected: (_) {
                            setState(() {
                              _analysisType = AnalysisType.timeWise;
                            });
                          },
                          backgroundColor: AppPallete.whiteColor,
                          selectedColor: AppPallete.buttonColor,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12)),
                        child: ChoiceChip(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "custom".tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _analysisType == AnalysisType.custom
                                    ? AppPallete.whiteColor
                                    : AppPallete.boxColor,
                              ),
                            ),
                          ),
                          selected: _analysisType == AnalysisType.custom,
                          onSelected: (_) {
                            setState(() {
                              _analysisType = AnalysisType.custom;
                            });
                          },
                          backgroundColor: AppPallete.whiteColor,
                          selectedColor: AppPallete.buttonColor,
                        ),
                      ),
                    ],
                  ),
                  if (_analysisType == AnalysisType.timeWise)
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
                  if (_analysisType == AnalysisType.timeWise)
                    if (_selectedAnalysis == 'today'.tr)
                      if (todayExpenses.isEmpty)
                        Text(
                          'no_expenses_today'.tr,
                        )
                      else
                        ExpensesAnalysisDisplays(
                          allExpenses: todayExpenses,
                          showDeleteDialog: _showDeleteDialog,
                          showEditBottomSheet: _showEditBottomSheet,
                          timeWise: 'today'.tr,
                        ),
                  if (_analysisType == AnalysisType.timeWise)
                    if (_selectedAnalysis == 'this_week'.tr)
                      if (weeklyExpenses.isEmpty)
                        Text(
                          'no_expenses_week'.tr,
                        )
                      else
                        ExpensesAnalysisDisplays(
                          allExpenses: weeklyExpenses,
                          showDeleteDialog: _showDeleteDialog,
                          showEditBottomSheet: _showEditBottomSheet,
                          timeWise: 'week'.tr,
                        ),
                  if (_analysisType == AnalysisType.timeWise)
                    if (_selectedAnalysis == 'this_month'.tr)
                      if (monhlyExpenses.isEmpty)
                        Text(
                          'no_expenses_month'.tr,
                        )
                      else
                        ExpensesAnalysisDisplays(
                          allExpenses: monhlyExpenses,
                          showDeleteDialog: _showDeleteDialog,
                          showEditBottomSheet: _showEditBottomSheet,
                          timeWise: 'month'.tr,
                        ),
                  if (_analysisType == AnalysisType.custom)
                    CustomAnalysisDisplay(
                      expense: state.expenses,
                    )
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
