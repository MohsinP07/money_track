import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/common/widgets/common_field.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/common/widgets/loader.dart';
import 'package:money_track/core/constants/constants.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:money_track/features/expenses/presentation/widgets/bottom_bar.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _expenseNameController = TextEditingController();
  final TextEditingController _expenseAmountController =
      TextEditingController();
  final TextEditingController _expenseDescriptionController =
      TextEditingController();
  final TextEditingController _expenseDateController = TextEditingController();
  var _selectedDate = DateTime.now();
  String selectedCategory = '';
  final formKey = GlobalKey<FormState>();

  void _presentDatePicker() async {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100))
        .then((value) {
      if (value != null) {
        setState(() {
          _selectedDate = value;
          _expenseDateController.text =
              DateFormat('dd-MMM-yyyy').format(_selectedDate);
        });
      }
    });
  }

  @override
  void dispose() {
    _expenseAmountController.dispose();
    _expenseDateController.dispose();
    _expenseDescriptionController.dispose();
    _expenseNameController.dispose();
    super.dispose();
  }

  void addExpense() {
    if (formKey.currentState!.validate() && selectedCategory != '') {
      final expenserId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      final expenserName =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.name;

      context.read<ExpensesBloc>().add(ExpenseAdd(
            name: _expenseNameController.text.trim(),
            description: _expenseDescriptionController.text.trim(),
            amount: _expenseAmountController.text.trim(),
            date: _selectedDate.toUtc(), // Convert to UTC before sending
            category: selectedCategory,
            expenserId: expenserId,
            expenserName: expenserName, isEdited: false,
          ));
      print(_selectedDate.toUtc()); // Ensure it prints UTC date
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenserId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    final expenserName =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.name;
    print(expenserId);
    print(expenserName);
    return Scaffold(
      body: BlocConsumer<ExpensesBloc, ExpensesState>(
        listener: (context, state) {
          if (state is ExpensesFailure) {
            showSnackBar(context, state.error);
            print(state.error);
          }
          if (state is AddExpensesSuccess) {
            showSnackBar(context, 'Added expense succcessfully!!');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomBar(initialPage: 0)),
                (route) => false);
          }
        },
        builder: (context, state) {
          if (state is ExpensesLoading) {
            return const Loader();
          }
          return SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0).copyWith(top: 20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      maxLines: 2,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Add ",
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
                    SizedBox(
                      height: deviceSize(context).height * 0.02,
                    ),
                    CommonTextField(
                      hintText: 'Expense Name',
                      controller: _expenseNameController,
                      leadingIcon: FontAwesomeIcons.moneyBill1,
                    ),
                    SizedBox(
                      height: deviceSize(context).height * 0.02,
                    ),
                    CommonTextField(
                      hintText: 'Expense Amount',
                      controller: _expenseAmountController,
                      leadingIcon: FontAwesomeIcons.indianRupeeSign,
                    ),
                    SizedBox(
                      height: deviceSize(context).height * 0.02,
                    ),
                    CommonTextField(
                      hintText: 'Expense Description',
                      controller: _expenseDescriptionController,
                      leadingIcon: Icons.info_outline,
                    ),
                    SizedBox(
                      height: deviceSize(context).height * 0.02,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CommonTextField(
                            hintText: 'Date',
                            isEnable: false,
                            controller: _expenseDateController,
                            leadingIcon: FontAwesomeIcons.calendar,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: _presentDatePicker,
                          icon: const Icon(
                            Icons.date_range_outlined,
                            color: AppPallete.boxColor,
                          ),
                          label: const Text(
                            'Select Date',
                            style: TextStyle(
                              color: AppPallete.boxColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: deviceSize(context).height * 0.02,
                    ),
                    const Text('Select category'),
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
                                      selectedCategory = e;
                                    });
                                    print(selectedCategory);
                                  },
                                  child: Chip(
                                    label: Text(
                                      e,
                                      style: TextStyle(
                                        color: selectedCategory == e
                                            ? AppPallete.whiteColor
                                            : AppPallete.blackColor,
                                      ),
                                    ),
                                    side: selectedCategory == e
                                        ? null
                                        : const BorderSide(
                                            color: AppPallete.borderColor,
                                          ),
                                    backgroundColor: selectedCategory == e
                                        ? AppPallete.buttonColor
                                        : null,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: deviceSize(context).height * 0.02,
                    ),
                    CustomButton(
                      text: 'Add Expense',
                      onTap: () {
                        addExpense();
                      },
                    )
                  ],
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}
