// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/common/widgets/loader.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/format_date.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:money_track/features/expenses/presentation/widgets/bottom_bar.dart';
import 'package:money_track/features/expenses/presentation/widgets/calculation_functions.dart';
import 'package:money_track/features/expenses/presentation/widgets/clock.dart';
import 'package:money_track/features/expenses/presentation/widgets/edit_bottom_sheet.dart';
import 'package:money_track/features/expenses/presentation/widgets/expense_summary.dart';
import 'package:money_track/features/expenses/presentation/widgets/expense_tile.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final sheetKey = GlobalKey<FormState>();

  void _goToAddExpensePage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const BottomBar(initialPage: 1)));
  }

  void _goToProfilePage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const BottomBar(initialPage: 3)));
  }

  @override
  void initState() {
    super.initState();
    context.read<ExpensesBloc>().add(ExpenseGetAllExpenses());
  }

  List<Expense> _filterTodayExpenses(List<Expense> expenses) {
    final today = DateTime.now();
    return expenses.where((expense) {
      final expenseDate = expense.date;
      return expenseDate.year == today.year &&
          expenseDate.month == today.month &&
          expenseDate.day == today.day;
    }).toList();
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

            double todaysExpense =
                CalculationFunctions.calculateTodaysExpense(todayExpenses);
                print(todaysExpense);
            double weeklyExpense =
                CalculationFunctions.calculateWeeklyExpense(state.expenses);
            double monthlyExpense =
                CalculationFunctions.calculateMonthlyExpense(state.expenses);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0).copyWith(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _goToProfilePage,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            maxLines: 2,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "hello".tr,
                                  style: const TextStyle(
                                    color: AppPallete.blackColor,
                                    fontSize: 30,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                TextSpan(
                                  text: userName,
                                  style: const TextStyle(
                                    color: AppPallete.blackColor,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: AppPallete.boxColor,
                            radius: deviceSize(context).width * 0.08,
                            child: Text(
                              userName.toString().substring(0, 1),
                              style: const TextStyle(
                                color: AppPallete.whiteColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: deviceSize(context).width * 0.01,
                    ),
                    Clock(),
                    SizedBox(
                      height: deviceSize(context).width * 0.02,
                    ),
                    ExpenseSummaryContainer(
                      height: deviceSize(context).height * 0.26,
                      width: double.infinity,
                      todaysExpense: todaysExpense,
                      weeklyExpense: weeklyExpense,
                      monthlyExpense: monthlyExpense,
                    ),
                    SizedBox(
                      height: deviceSize(context).height * 0.01,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                          width: deviceSize(context).width * 0.4,
                          child: CustomButton(
                              text: 'add_expense'.tr,
                              onTap: _goToAddExpensePage)),
                    ),
                    SizedBox(
                      height: deviceSize(context).height * 0.02,
                    ),
                    if (todayExpenses.isEmpty)
                      Text(
                        'no_expenses_today'.tr,
                      ),
                    if (todayExpenses.isNotEmpty)
                      Text(
                        'today'.tr,
                      ),
                    SizedBox(
                      height: deviceSize(context).height * 0.01,
                    ),
                    Expanded(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                _showDeleteDialog(
                                  context,
                                  expense.id!,
                                  expense.name,
                                );
                              },
                              child: GestureDetector(
                                onTap: () =>
                                    _showEditBottomSheet(context, expense),
                                child: ExpenseTile(
                                  icon: CalculationFunctions.decideIcon(
                                      expense.category),
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
                    )
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
