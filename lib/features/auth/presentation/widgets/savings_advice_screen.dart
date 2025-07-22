import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:money_track/core/common/widgets/loader.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/utils.dart';
import 'package:money_track/features/expenses/domain/entity/expense.dart';
import '../../../expenses/presentation/bloc/expenses_bloc.dart';
import 'package:markdown/markdown.dart' as md;

class SavingsAdviceScreen extends StatefulWidget {
  static const String routeName = "savings-advice-screen";
  const SavingsAdviceScreen({super.key});

  @override
  State<SavingsAdviceScreen> createState() => SavingsAdviceScreenState();
}

class SavingsAdviceScreenState extends State<SavingsAdviceScreen> {
  String? _adviceHtml;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<ExpensesBloc>().add(ExpenseGetAllExpenses());
  }

  List<Expense> _filterOneMonthExpenses(List<Expense> expenses) {
    final today = DateTime.now();
    final startOfMonth = DateTime(today.year, today.month, 1);
    final endOfMonth = DateTime(today.year, today.month + 1, 0);

    final filteredExpenses = expenses.where((expense) {
      final date = expense.date;
      return date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          date.isBefore(endOfMonth.add(const Duration(days: 1)));
    }).toList();

    filteredExpenses.sort((a, b) => b.date.compareTo(a.date));
    return filteredExpenses;
  }

  Widget _buildExpenseSummary(List<Expense> expenses) {
    final Map<String, double> categoryTotals = {};
    for (final expense in expenses) {
      final category = expense.category;
      categoryTotals[category] =
          (categoryTotals[category] ?? 0) + double.parse(expense.amount);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "This Month's Expense Summary",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppPallete.boxColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppPallete.borderColor),
          ),
          child: DataTable(
            columns: const [
              DataColumn(
                label: Text('Category',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              DataColumn(
                label: Text('Amount ₹',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
            rows: categoryTotals.entries.map((entry) {
              return DataRow(cells: [
                DataCell(Text(entry.key)),
                DataCell(Text(entry.value.toStringAsFixed(2))),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchSavingsAdvice(List<Expense> expenses) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final expenseMap = expenses
          .map((e) => {
                'name': e.name,
                'description': e.description,
                'category': e.category,
                'date': e.date.toIso8601String()
              })
          .toList();

      final prompt = '''
            You are a financial advisor. Analyze this monthly expense data from an Indian user:
            ${jsonEncode(expenseMap)}

            Based on this, give 3–5 personalized savings suggestions.

            **Please format your response using Markdown with the following:**
            * **Main headings** (e.g., "## Savings Tips")
            * **Subheadings** (e.g., "### Avoiding Unnecessary Subscriptions")
            * **Bullet points** for practical advice
            * **Bold text** for important points
            * **Horizontal rules** (---) to separate sections

            Keep it practical, avoid technical jargon, and ensure it's easy to understand for general users.
            ''';

      final rawMarkdown = await getAdviceFromGemini(prompt);
      final html = md.markdownToHtml(rawMarkdown);

      setState(() {
        _adviceHtml = html;
      });
    } catch (e) {
      showSnackBar(context, "Failed to get advice: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> getAdviceFromGemini(String prompt) async {
    const String endpoint =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

    final Map<String, dynamic> body = {
      "contents": [
        {
          "parts": [
            {
              "text": prompt,
            }
          ]
        }
      ]
    };

    String geminiApiKey = dotenv.env['GEMINI_API'] ?? '';

    final response = await http.post(
      Uri.parse("$endpoint?key=$geminiApiKey"),
      headers: {
        'Content-Type': 'application/json',
        'X-goog-api-key': geminiApiKey,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final String text = data['candidates'][0]['content']['parts'][0]['text'];
      return text;
    } else {
      print("Gemini Error: ${response.statusCode}, ${response.body}");
      return "Something went wrong while fetching advice. Please try again.";
    }
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
            final monthlyExpenses = _filterOneMonthExpenses(state.expenses);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  RichText(
                    maxLines: 2,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Savings",
                          style: TextStyle(
                            color: AppPallete.blackColor,
                            fontSize: 30,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextSpan(
                          text: " Advice",
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
                  const SizedBox(height: 20),
                  _buildExpenseSummary(monthlyExpenses),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () => _fetchSavingsAdvice(monthlyExpenses),
                    icon: const Icon(
                      FontAwesomeIcons.robot,
                      color: AppPallete.whiteColor,
                      size: 18,
                    ),
                    label: const Text(
                      " Generate Savings Tips",
                      style: TextStyle(
                        color: AppPallete.whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.borderColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "Getting you personalised advice.....",
                            style: TextStyle(
                              color: AppPallete.blackColor,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Lottie.asset('assets/shimmers/mt_loading.json'),
                        ],
                      ),
                    ),
                  if (_adviceHtml != null && _adviceHtml!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppPallete.boxColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppPallete.borderColor),
                      ),
                      child: HtmlWidget(
                        _adviceHtml!,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: AppPallete.blackColor,
                          fontFamily: 'Poppins',
                          height: 1.5,
                        ),
                        customStylesBuilder: (element) {
                          switch (element.localName) {
                            case 'h1':
                            case 'h2':
                              return {
                                'font-size': '20px',
                                'font-weight': 'bold',
                                'color': '#000000',
                                'margin': '16px 0 8px',
                              };
                            case 'h3':
                              return {
                                'font-size': '18px',
                                'font-weight': 'bold',
                                'margin': '14px 0 6px',
                              };
                            case 'ul':
                            case 'ol':
                              return {'margin-left': '20px'};
                            case 'hr':
                              return {
                                'border-top': '1px solid #ccc',
                                'margin': '12px 0',
                              };
                          }
                          return null;
                        },
                      ),
                    )
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
