import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoneyBotAI extends StatefulWidget {
  static const String routename = '/moneybot-page';
  const MoneyBotAI({super.key});

  @override
  State<MoneyBotAI> createState() => _MoneyBotAIState();
}

class _MoneyBotAIState extends State<MoneyBotAI> {
  late Future<SharedPreferences> _prefs;
  bool _showDialog = false;

  @override
  void initState() {
    super.initState();
    _prefs = SharedPreferences.getInstance();
  }

  Future<void> _checkIfFirstTime(SharedPreferences prefs) async {
    bool showDialog = prefs.getBool('showDialog') ?? true;
    if (showDialog) {
      await _showIncomeInfoDialog(context, prefs);
    }
  }

  Future<void> _showIncomeInfoDialog(
      BuildContext context, SharedPreferences prefs) async {
    TextEditingController monthlyIncomeController = TextEditingController();
    TextEditingController annualIncomeController = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Please Enter Income Information',
          style: TextStyle(
            color: Colors.red.shade300,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: monthlyIncomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Monthly Income in ₹',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter monthly income';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: annualIncomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Annual Income in ₹',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter annual income';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (monthlyIncomeController.text.isEmpty ||
                  annualIncomeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Please enter both incomes'),
                ));
                return;
              }

              await prefs.setBool('showDialog', false);
              await prefs.setString(
                  'monthlyIncome', monthlyIncomeController.text.trim());
              await prefs.setString(
                  'annualIncome', annualIncomeController.text.trim());

              setState(() {
                _showDialog = false;
              });
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        (context.watch<AppUserCubit>().state as AppUserLoggedIn).user.name;

    return FutureBuilder<SharedPreferences>(
      future: _prefs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final prefs = snapshot.data!;
          if (!_showDialog) {
            _checkIfFirstTime(prefs);
            _showDialog = true; // Ensures it only shows once
          }

          return Scaffold(
            backgroundColor: AppPallete.botBgColor,
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppPallete.buttonColor,
                          radius: deviceSize(context).width * 0.06,
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: AppPallete.whiteColor,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: AppPallete.buttonColor,
                          radius: deviceSize(context).width * 0.06,
                          child: const Center(
                            child: Icon(
                              FontAwesomeIcons.robot,
                              color: AppPallete.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: deviceSize(context).height * 0.02,
                    ),
                    RichText(
                      maxLines: 2,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Hello, ',
                            style: TextStyle(
                              color: AppPallete.blackColor,
                              fontSize: 30,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          TextSpan(
                            text: "${userName.split(' ').first} ",
                            style: const TextStyle(
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
                      height: deviceSize(context).height * 0.01,
                    ),
                    const Text(
                      'How can I assist you right now?',
                      style: TextStyle(
                        color: AppPallete.blackColor,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(
                      height: deviceSize(context).height * 0.02,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: deviceSize(context).height * 0.30,
                            width: deviceSize(context).width * 0.46,
                            decoration: BoxDecoration(
                              color: AppPallete.boxColor,
                              borderRadius: BorderRadius.circular(10).copyWith(
                                bottomLeft: const Radius.circular(36),
                              ),
                            ),
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.thinkPeaks,
                                  color: AppPallete.whiteColor,
                                  size: 28,
                                ),
                                SizedBox(
                                  height: deviceSize(context).height * 0.03,
                                ),
                                RichText(
                                  maxLines: 3,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Investment\n',
                                        style: TextStyle(
                                          color: AppPallete.whiteColor,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Advice\n',
                                        style: TextStyle(
                                          color: AppPallete.whiteColor,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'by MoneyBot.',
                                        style: TextStyle(
                                          color: AppPallete.whiteColor,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                height: deviceSize(context).height * 0.13,
                                width: deviceSize(context).width * 0.34,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 128, 97, 136),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.bank,
                                      color: AppPallete.whiteColor,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      height: deviceSize(context).height * 0.01,
                                    ),
                                    RichText(
                                      maxLines: 3,
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Savings\n',
                                            style: TextStyle(
                                              color: AppPallete.whiteColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Advice',
                                            style: TextStyle(
                                              color: AppPallete.whiteColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: deviceSize(context).height * 0.026,
                              ),
                              Container(
                                height: deviceSize(context).height * 0.13,
                                width: deviceSize(context).width * 0.34,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 167, 114, 181),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.moneyBill,
                                      color: AppPallete.whiteColor,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      height: deviceSize(context).height * 0.01,
                                    ),
                                    RichText(
                                      maxLines: 3,
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Expenses\n',
                                            style: TextStyle(
                                              color: AppPallete.whiteColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Advice',
                                            style: TextStyle(
                                              color: AppPallete.whiteColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: deviceSize(context).height * 0.02,
                    ),
                    TextButton(
                      onPressed: () {
                        _showIncomeInfoDialog(context, prefs);
                      },
                      child: const Text('Set Budget'),
                    ),
                    if (prefs.containsKey('monthlyIncome'))
                      Text("${prefs.getString('monthlyIncome')}"),
                    if (prefs.containsKey('annualIncome'))
                      Text("${prefs.getString('annualIncome')}")
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
