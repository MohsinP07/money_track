import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/common/widgets/loader.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/format_date.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/expenses/data/models/expense_model.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:money_track/features/expenses/presentation/widgets/bottom_bar.dart';
import 'package:money_track/features/expenses/presentation/widgets/expense_tile.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  void _goToAddExpensePage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const BottomBar(initialPage: 1)));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ExpensesBloc, ExpensesState>(
        listener: (context, state) {
          if (state is ExpensesFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is ExpensesLoading) {
            return const Loader();
          }
          if (state is ExpensesDisplaySuccess) {
            final todayExpenses = _filterTodayExpenses(state.expenses);
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0).copyWith(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          maxLines: 2,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Hello\n",
                                style: TextStyle(
                                  color: AppPallete.blackColor,
                                  fontSize: 30,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              TextSpan(
                                text: "User",
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
                        CircleAvatar(
                          backgroundColor: AppPallete.boxColor,
                          radius: deviceSize(context).width * 0.08,
                          child: const Text(
                            'U',
                            style: TextStyle(color: AppPallete.whiteColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: deviceSize(context).width * 0.08,
                    ),
                    Container(
                      height: deviceSize(context).height * 0.2,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppPallete.boxColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          maxLines: 2,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Expenses\n",
                                style: TextStyle(
                                  color: AppPallete.whiteColor,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              TextSpan(
                                text: "₹20000",
                                style: TextStyle(
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
                    ),
                    SizedBox(
                      height: deviceSize(context).height * 0.01,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                          width: deviceSize(context).width * 0.4,
                          child: CustomButton(
                              text: 'Add Expense', onTap: _goToAddExpensePage)),
                    ),
                    SizedBox(
                      height: deviceSize(context).height * 0.02,
                    ),
                    const Text('Today'),
                    SizedBox(
                      height: deviceSize(context).height * 0.01,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: todayExpenses.length,
                          itemBuilder: (context, index) {
                            final expense = todayExpenses[index];
                            return ExpenseTile(
                              icon: 'assets/images/mor_dash.png',
                              title: expense.name,
                              subtitle: expense.category,
                              amount: expense.amount,
                              date: formatDatedMMMYYYY(expense.date),
                            );
                          }),
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
