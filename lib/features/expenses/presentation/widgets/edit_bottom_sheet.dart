import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/constants/constants.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:money_track/features/expenses/presentation/widgets/calculation_functions.dart';
import 'package:money_track/features/expenses/presentation/widgets/sheet_textfield.dart';

class EditExpenseBottomSheet extends StatefulWidget {
  final Expense expense;

  const EditExpenseBottomSheet({Key? key, required this.expense})
      : super(key: key);

  @override
  _EditExpenseBottomSheetState createState() => _EditExpenseBottomSheetState();
}

class _EditExpenseBottomSheetState extends State<EditExpenseBottomSheet> {
  final GlobalKey<FormState> _sheetKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.expense.name);
    _amountController = TextEditingController(text: widget.expense.amount);
    _descriptionController =
        TextEditingController(text: widget.expense.description);
    _selectedCategory = widget.expense.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _sheetKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit Expense',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Image.asset(
                        CalculationFunctions.decideIcon(_selectedCategory),
                        height: 24,
                        width: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SheetTextField(controller: _nameController, label: 'Name'),
                  const SizedBox(height: 8),
                  SheetTextField(
                      controller: _amountController, label: 'Amount'),
                  const SizedBox(height: 8),
                  SheetTextField(
                      controller: _descriptionController, label: 'Description'),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppPallete.boxColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 80,
                        child: CustomButton(
                          onTap: () {
                            if (_sheetKey.currentState!.validate()) {
                              context.read<ExpensesBloc>().add(ExpenseEdit(
                                    id: widget.expense.id!,
                                    name: _nameController.text,
                                    amount: _amountController.text,
                                    description: _descriptionController.text,
                                    category: _selectedCategory,
                                    date: widget.expense.date,
                                  ));
                              Navigator.of(context).pop();
                            }
                          },
                          text: 'Save',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
