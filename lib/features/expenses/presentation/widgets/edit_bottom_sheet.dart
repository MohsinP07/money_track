import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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
  bool _isSaveButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.expense.name);
    _amountController = TextEditingController(text: widget.expense.amount);
    _descriptionController =
        TextEditingController(text: widget.expense.description);
    _selectedCategory = widget.expense.category;

    _nameController.addListener(_checkForChanges);
    _amountController.addListener(_checkForChanges);
    _descriptionController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkForChanges);
    _amountController.removeListener(_checkForChanges);
    _descriptionController.removeListener(_checkForChanges);

    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    setState(() {
      _isSaveButtonVisible = _nameController.text.trim() !=
              widget.expense.name ||
          _amountController.text.trim() != widget.expense.amount ||
          _descriptionController.text.trim() != widget.expense.description ||
          _selectedCategory != widget.expense.category;
    });
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
                      Text(
                        'edit_expense'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            CalculationFunctions.decideIcon(_selectedCategory),
                            height: 24,
                            width: 24,
                          ),
                          if (widget.expense.isEdited)
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "edited".tr,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SheetTextField(controller: _nameController, label: 'name'.tr),
                  const SizedBox(height: 8),
                  SheetTextField(
                      controller: _amountController, label: 'amount'.tr),
                  const SizedBox(height: 8),
                  SheetTextField(
                      controller: _descriptionController,
                      label: 'desc'.removeAllWhitespace),
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
                                  _checkForChanges(); // Call to check changes when category is updated
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
                        child: Text(
                          'cancel'.tr,
                          style: const TextStyle(
                            color: AppPallete.boxColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Visibility(
                        visible: _isSaveButtonVisible,
                        child: SizedBox(
                            width: 80,
                            child: CustomButton(
                              onTap: () {
                                if (_sheetKey.currentState!.validate()) {
                                  context.read<ExpensesBloc>().add(ExpenseEdit(
                                        id: widget.expense.id!,
                                        name: _nameController.text,
                                        amount: _amountController.text,
                                        description:
                                            _descriptionController.text,
                                        category: _selectedCategory,
                                        date: widget.expense.date,
                                        isEdited: true,
                                      ));
                                  Navigator.of(context).pop();
                                }
                              },
                              text: 'save'.tr,
                            )),
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
