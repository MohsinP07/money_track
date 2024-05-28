import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/constants/constants.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/expenses/presentation/widgets/expense_tile.dart';

class AnalyzeExpensePage extends StatefulWidget {
  const AnalyzeExpensePage({super.key});

  @override
  State<AnalyzeExpensePage> createState() => _AnalyzeExpensePageState();
}

class _AnalyzeExpensePageState extends State<AnalyzeExpensePage> {
  String _selectedAnalysis = '';
  String _selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    final userId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    final userName =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.name;
    return Scaffold(
      body: SafeArea(
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
            if (_selectedAnalysis != 'Custom')
              Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const ExpenseTile(
                        icon: 'assets/images/mor_dash.png',
                        title: 'Nike Store',
                        subtitle: 'Clothing',
                        amount: '5000',
                        date: '22-05-2024',
                      );
                    }),
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
      )),
    );
  }
}
