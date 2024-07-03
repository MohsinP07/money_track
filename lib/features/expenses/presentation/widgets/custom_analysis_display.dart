import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/common/widgets/custom_dialog.dart';
import 'package:money_track/core/common/widgets/reports_generator.dart';
import 'package:money_track/core/constants/constants.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:money_track/features/expenses/presentation/widgets/expense_tile.dart';
import 'package:money_track/features/expenses/presentation/widgets/calculation_functions.dart';
import 'package:money_track/core/utils/format_date.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

enum ExportType { pdf, excel, viewHere }

class CustomAnalysisDisplay extends StatefulWidget {
  final List<Expense> expense;
  const CustomAnalysisDisplay({super.key, required this.expense});

  @override
  State<CustomAnalysisDisplay> createState() => _CustomAnalysisDisplayState();
}

class _CustomAnalysisDisplayState extends State<CustomAnalysisDisplay> {
  String _selectedCategory = 'All';
  var _selectedStartDate = DateTime.now();
  var _selectedEndDate = DateTime.now();
  var _exportType = ExportType.viewHere;
  final reportGenerator = ReportGenerator();

  void _presentDatePicker(DateTime date, String type) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1999),
            lastDate: DateTime.now())
        .then((value) => value != null
            ? setState(() {
                if (type == 's') {
                  _selectedStartDate = value;
                } else {
                  _selectedEndDate = value;
                }
              })
            : '');
  }

  Widget datePickerButton(Size deviceSize, DateTime date, String type) {
    return Container(
      padding: EdgeInsets.all(5),
      width: deviceSize.width * 0.4,
      height: deviceSize.height * 0.06,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppPallete.borderColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              date == null
                  ? 'No Date Choosen'
                  : DateFormat.yMMMd().format(date),
              style: const TextStyle(
                fontSize: 14,
                color: AppPallete.buttonColor,
              ),
            ),
          ),
          TextButton(
              onPressed: () => _presentDatePicker(date, type),
              child: const Text('Choose date',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.boxColor,
                  ))),
        ],
      ),
    );
  }

  List<Expense> _filterExpenses() {
    final filteredExpenses = widget.expense.where((expense) {
      final isWithinCategory =
          _selectedCategory == 'All' || expense.category == _selectedCategory;
      final isWithinDateRange = expense.date.isAfter(_selectedStartDate) &&
          expense.date.isBefore(_selectedEndDate.add(Duration(days: 1)));

      return isWithinCategory && isWithinDateRange;
    }).toList();

    filteredExpenses.sort((a, b) => b.date.compareTo(a.date));

    return filteredExpenses;
  }

  void _showFilteredExpenses() {
    final filteredExpenses = _filterExpenses();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7, // Set this to 70% of the screen height
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filtered expenses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.cancel,
                        ))
                  ],
                ),
                const SizedBox(height: 10),
                filteredExpenses.isEmpty
                    ? const Text('No expenses found for the selected criteria.')
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredExpenses.length,
                          itemBuilder: (context, index) {
                            final expense = filteredExpenses[index];
                            return ExpenseTile(
                              icon: CalculationFunctions.decideIcon(
                                  expense.category),
                              title: expense.name,
                              subtitle: expense.category,
                              amount: expense.amount,
                              date: formatDatedMMMYYYY(expense.date),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCustomDialog(BuildContext context, VoidCallback onView) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          icon: Icons.check,
          submitName: "View",
          title: 'Reports ready',
          content: 'Your reports are ready to view.',
          onView: onView,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Custom Filtered Analysis"),
          SizedBox(
            height: deviceSize(context).height * 0.01,
          ),
          const Divider(),
          const Text(
            "Select Category",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: deviceSize(context).height * 0.01,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: Constants.analysisExpenseCategory
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
          const Divider(),
          SizedBox(
            height: deviceSize(context).height * 0.01,
          ),
          const Text(
            "Select start and end date",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: deviceSize(context).height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              datePickerButton(deviceSize(context), _selectedStartDate, 's'),
              datePickerButton(deviceSize(context), _selectedEndDate, 'e'),
            ],
          ),
          SizedBox(
            height: deviceSize(context).height * 0.01,
          ),
          const Divider(),
          SizedBox(
            height: deviceSize(context).height * 0.01,
          ),
          const Text(
            "Select export type",
            style: TextStyle(
              fontWeight: FontWeight.bold,
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
                      "View Here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _exportType == ExportType.viewHere
                            ? AppPallete.whiteColor
                            : AppPallete.boxColor,
                      ),
                    ),
                  ),
                  selected: _exportType == ExportType.viewHere,
                  onSelected: (_) {
                    setState(() {
                      _exportType = ExportType.viewHere;
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
                      "PDF",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _exportType == ExportType.pdf
                            ? AppPallete.whiteColor
                            : AppPallete.boxColor,
                      ),
                    ),
                  ),
                  selected: _exportType == ExportType.pdf,
                  onSelected: (_) {
                    setState(() {
                      _exportType = ExportType.pdf;
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
                      "Excel",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _exportType == ExportType.excel
                            ? AppPallete.whiteColor
                            : AppPallete.boxColor,
                      ),
                    ),
                  ),
                  selected: _exportType == ExportType.excel,
                  onSelected: (_) {
                    setState(() {
                      _exportType = ExportType.excel;
                    });
                  },
                  backgroundColor: AppPallete.whiteColor,
                  selectedColor: AppPallete.buttonColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: deviceSize(context).height * 0.01,
          ),
          const Divider(),
          CustomButton(
            text: "Submit",
            onTap: () async {
              if (_exportType == ExportType.viewHere) {
                _showFilteredExpenses();
              } else if (_exportType == ExportType.pdf &&
                  _filterExpenses().isNotEmpty) {
                _showCustomDialog(context, () async {
                  final pdf = await reportGenerator.createPDF(
                      _filterExpenses(),
                      'Custom Reports',
                      _selectedStartDate.toString(),
                      _selectedEndDate.toString(),
                      _selectedCategory,
                      '');
                  final filePath = await reportGenerator.savePDF(pdf);
                  OpenFile.open(filePath);
                });
              } else if (_exportType == ExportType.excel &&
                  _filterExpenses().isNotEmpty) {
                _showCustomDialog(context, () async {
                  await reportGenerator.createAndSaveExcel(
                    _filterExpenses(),
                    'Custom Reports',
                    _selectedStartDate.toString(),
                    _selectedEndDate.toString(),
                    _selectedCategory,
                    '',
                  );
                });
              } else {
                showSnackBar(context, 'No Expenses!!');
              }
            },
          ),
          const Divider()
        ],
      ),
    );
  }
}
