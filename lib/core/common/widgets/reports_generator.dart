import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_track/core/utils/format_date.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'dart:io'; // Import your Expense model here

class ReportGenerator {
  Future<pw.Document> createPDF(
    List<Expense> filteredExpenses,
    String reportName,
    String? selectedStartDate,
    String? selectedEndDate,
    String? selectedCategory,
    String? timeWise,
  ) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy');

    final collectionNewHeaders = [
      'Sr. No',
      'Date',
      'Name',
      if (reportName != 'Custom Reports') 'Category',
      'Amount',
    ];

    final expenseData = filteredExpenses.asMap().entries.map((entry) {
      int index = entry.key + 1;
      Expense expense = entry.value;
      List<String> row = [
        index.toString(),
        dateFormat.format(DateTime.parse(expense.date.toString())),
        expense.name.toLowerCase(),
        if (reportName != 'Custom Reports') expense.category.toString(),
        expense.amount.toString(),
      ];
      return row;
    }).toList();

    // Load custom fonts
    final fontData = await rootBundle.load('assets/fonts/OpenSans-Regular.ttf');
    final fontBoldData =
        await rootBundle.load('assets/fonts/OpenSans-Bold.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());
    final ttfBold = pw.Font.ttf(fontBoldData.buffer.asByteData());

    pdf.addPage(
      pw.MultiPage(
        maxPages: 100,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("MoneyTrack",
                    style: pw.TextStyle(fontSize: 24, font: ttfBold)),
                pw.Text(reportName,
                    style: pw.TextStyle(fontSize: 18, font: ttfBold)),
              ],
            ),
          ),
          if (reportName == 'Custom Reports')
            pw.Text(
              'Dated from ${dateFormat.format(DateTime.parse(selectedStartDate!))} to ${dateFormat.format(DateTime.parse(selectedEndDate!))}',
              style: pw.TextStyle(
                  fontSize: 12, font: ttf, fontStyle: pw.FontStyle.italic),
            ),
          if (reportName == 'Custom Reports' && selectedCategory != null)
            pw.Text('Category: $selectedCategory'),
          pw.SizedBox(height: 10),
          if (reportName != 'Custom Reports') pw.Text('$timeWise Expenses'),
          if (reportName != 'Custom Reports') pw.SizedBox(height: 10),
          pw.Text(
            "Your Financial Activity Summary",
            style: pw.TextStyle(fontSize: 14, font: ttfBold),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "All Expenses",
            style: pw.TextStyle(
                fontSize: 16,
                font: ttfBold,
                decoration: pw.TextDecoration.underline),
          ),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headerPadding:
                const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            headers: collectionNewHeaders,
            data: expenseData,
            cellPadding: const pw.EdgeInsets.all(4),
            headerStyle: pw.TextStyle(
                fontSize: 10, font: ttfBold, color: PdfColors.white),
            cellAlignment: pw.Alignment.centerLeft,
            cellStyle: pw.TextStyle(fontSize: 10, font: ttf),
            border: pw.TableBorder.all(width: 1, color: PdfColors.grey700),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.purple200),
          ),
        ],
        footer: (context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style:
                  pw.TextStyle(color: PdfColors.grey, fontSize: 12, font: ttf),
            ),
          );
        },
      ),
    );

    return pdf;
  }

  // Function to save the PDF document to a file
  Future<String> savePDF(pw.Document pdf) async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/expense-details.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  // Function to create and save an Excel document from a list of expenses
  Future<void> createAndSaveExcel(
    List<Expense> filteredExpenses,
    String reportName,
    String? selectedStartDate,
    String? selectedEndDate,
    String? selectedCategory,
    String? timeWise,
  ) async {
    final excel.Workbook workbook = excel.Workbook();
    final excel.Worksheet sheet = workbook.worksheets[0];

    int counter = 1;

    sheet.getRangeByName('A$counter').setText('Expenses');
    counter++;

    if (reportName != 'Custom Reports') {
      sheet.getRangeByName('A$counter').setText('$timeWise Expenses');
      counter++;
    }

    if (reportName == 'Custom Reports') {
      sheet.getRangeByName('A$counter').setText(
          '${reportName}- From ${formatDatedMMMYYYY(DateTime.parse(selectedStartDate!))} To ${formatDatedMMMYYYY(DateTime.parse(selectedEndDate!))}');
      counter++;

      if (selectedCategory != null) {
        sheet
            .getRangeByName('A$counter')
            .setText('Category: $selectedCategory');
        counter++;
      }
    } else {
      sheet.getRangeByName('A$counter').setText(reportName);
      counter++;
    }

    // Headers
    List<String> headers = [
      'Sr. No',
      'Date',
      'Name',
      if (reportName != 'Custom Reports') 'Category',
      'Amount'
    ];
    for (int i = 0; i < headers.length; i++) {
      excel.Range headerCell =
          sheet.getRangeByName('${String.fromCharCode(65 + i)}$counter');
      headerCell.setText(headers[i]);
      headerCell.cellStyle.backColorRgb = Colors.purple.shade200;
      headerCell.cellStyle.borders.all.lineStyle = excel.LineStyle.thin;
    }
    counter++;

    // Data
    for (var i = 0; i < filteredExpenses.length; i++) {
      Expense expense = filteredExpenses[i];
      List<dynamic> recordList = [
        (i + 1).toString(),
        DateFormat('dd/MM/yyyy').format(expense.date),
        expense.name.toLowerCase(),
        if (reportName != 'Custom Reports') expense.category.toString(),
        expense.amount.toString(),
      ];
      for (int j = 0; j < recordList.length; j++) {
        excel.Range dataCell =
            sheet.getRangeByName('${String.fromCharCode(65 + j)}$counter');
        dataCell.setText(recordList[j]);
        dataCell.cellStyle.borders.all.lineStyle = excel.LineStyle.thin;
      }
      counter++;
    }

    final List<int> bytes = workbook.saveAsStream();

    final path = (await getTemporaryDirectory()).path;
    String fileName =
        '$path/ExpenseReport-${DateFormat('dd-MM-yyyy').format(DateTime.now())}.xlsx';

    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }
}
