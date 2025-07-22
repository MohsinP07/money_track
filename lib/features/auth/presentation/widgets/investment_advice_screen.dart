import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:markdown/markdown.dart' as md;

class InvestmentAdviceScreen extends StatefulWidget {
  static const String routeName = "investment-advice-screen";
  const InvestmentAdviceScreen({super.key});

  @override
  State<InvestmentAdviceScreen> createState() => _InvestmentAdviceScreenState();
}

class _InvestmentAdviceScreenState extends State<InvestmentAdviceScreen> {
  late SharedPreferences prefs;

  final monthlyIncomeController = TextEditingController();
  final annualIncomeController = TextEditingController();
  final percentController = TextEditingController();

  String riskLevel = 'Medium';
  String investmentGoal = 'Long-term';

  String? aiAdvice;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      monthlyIncomeController.text = prefs.getString('monthlyIncome') ?? '';
      annualIncomeController.text = prefs.getString('annualIncome') ?? '';
    });
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

  void _getInvestmentAdvice() async {
    await prefs.setString('monthlyIncome', monthlyIncomeController.text);
    await prefs.setString('annualIncome', annualIncomeController.text);

    setState(() {
      _isLoading = true;
      aiAdvice = null;
    });

    try {
      final monthly = monthlyIncomeController.text.trim();
      final annual = annualIncomeController.text.trim();
      final percent = percentController.text.trim();

      if (monthly.isEmpty || annual.isEmpty || percent.isEmpty) {
        setState(() {
          aiAdvice =
              "Please fill in all income and investment percentage fields.";
          _isLoading = false;
        });
        return;
      }

      final prompt = '''
        You are a financial expert. Give detailed and structured investment advice for someone in India with the following details:
        - Monthly Income: ₹$monthly
        - Annual Income: ₹$annual
        - Wants to invest: $percent% of income
        - Goal: $investmentGoal
        - Risk Appetite: $riskLevel

        **Please format your response using Markdown, including:**
        * **Main headings** (e.g., "## Personalized Investment Advice")
        * **Subheadings** (e.g., "### Key Investment Avenues")
        * **Tables** where appropriate (e.g., for financial profile or allocation). Ensure tables are well-formed in Markdown.
        * **Bold text** for emphasis.
        * **Bullet points** for lists.
        * **Horizontal rules** (---) to separate sections.

        Give real-world suggestions like SIPs, FDs, PPF, equity, mutual funds, etc., suitable for Indian standards. Ensure the language is easy to understand for a general user.
        Avoid tables but dont mention this in response as it will not look good for users to see this
''';

      final advice = await getAdviceFromGemini(prompt);
      setState(() {
        aiAdvice = md.markdownToHtml(advice);
      });
    } catch (e) {
      setState(() {
        aiAdvice = "Error fetching advice: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(10.0).copyWith(top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                maxLines: 2,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Investment",
                      style: TextStyle(
                        color: AppPallete.blackColor,
                        fontSize: 30,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextSpan(
                      text: "Advice",
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
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Fill the fields so that we can provide you detailed insights",
                style: TextStyle(
                  color: AppPallete.blackColor,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildTextField("Monthly Income (₹)", monthlyIncomeController),
              const SizedBox(height: 12),
              _buildTextField("Annual Income (₹)", annualIncomeController),
              const SizedBox(height: 12),
              _buildTextField("Investment % of Salary", percentController),
              const SizedBox(height: 12),
              _buildDropdown(
                "Investment Goal",
                ["Short-term", "Long-term"],
                investmentGoal,
                (value) => setState(() => investmentGoal = value!),
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                "Risk Appetite",
                ["Low", "Medium", "High"],
                riskLevel,
                (value) => setState(() => riskLevel = value!),
              ),
              const SizedBox(height: 20),
              if (!_isLoading)
                CustomButton(
                  text: 'Get Advice',
                  onTap: () {
                    if (!_isLoading) _getInvestmentAdvice();
                  },
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
                )
              else if (aiAdvice != null &&
                  aiAdvice!.isNotEmpty) // Check if advice is not empty
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppPallete.boxColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppPallete.borderColor),
                  ),
                  child: HtmlWidget(
                    // NEW: Use HtmlWidget to render the HTML
                    aiAdvice!,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: AppPallete.blackColor,
                      fontFamily: 'Poppins',
                      height: 1.5,
                    ),
                    // Customize heading styles using customStylesMap
                    customStylesBuilder: (element) {
                      if (element.localName == 'h1') {
                        return {
                          'font-size': '24px',
                          'font-weight': 'bold',
                          'color': '#000000', // Assuming blackColor
                          'font-family': 'Poppins',
                          'margin-top': '20px',
                          'margin-bottom': '10px',
                        };
                      } else if (element.localName == 'h2') {
                        return {
                          'font-size': '22px',
                          'font-weight': 'bold',
                          'color': '#000000',
                          'font-family': 'Poppins',
                          'margin-top': '18px',
                          'margin-bottom': '8px',
                        };
                      } else if (element.localName == 'h3') {
                        return {
                          'font-size': '20px',
                          'font-weight': 'bold',
                          'color': '#000000',
                          'font-family': 'Poppins',
                          'margin-top': '16px',
                          'margin-bottom': '6px',
                        };
                      } else if (element.localName == 'h4') {
                        return {
                          'font-size': '18px',
                          'font-weight': 'bold',
                          'color': '#000000',
                          'font-family': 'Poppins',
                          'margin-top': '14px',
                          'margin-bottom': '4px',
                        };
                      } else if (element.localName == 'strong' ||
                          element.localName == 'b') {
                        return {'font-weight': 'bold', 'color': '#000000'};
                      } else if (element.localName == 'table') {
                        return {'border-collapse': 'collapse', 'width': '100%'};
                      } else if (element.localName == 'th' ||
                          element.localName == 'td') {
                        return {
                          'border': '1px solid #CCCCCC', // borderColor
                          'padding': '8px',
                          'text-align': 'left',
                          'font-family': 'Poppins',
                        };
                      } else if (element.localName == 'ul' ||
                          element.localName == 'ol') {
                        return {'margin-left': '20px'}; // Indent for lists
                      }
                      return null; // Use default styles
                    },
                  ),
                )
              else if (aiAdvice != null &&
                  aiAdvice!.isEmpty) // Case for empty advice but not null
                const Text(
                    "No advice generated. Please try again with valid inputs.")
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
