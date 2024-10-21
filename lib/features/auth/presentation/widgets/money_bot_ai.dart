import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_track/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/advice_box.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/all_finance_goals.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/create_finance_goals.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/investment_box.dart';
import 'package:money_track/features/auth/presentation/widgets/income_info_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoneyBotAI extends StatefulWidget {
  static const String routename = '/moneybot-page';
  const MoneyBotAI({super.key});

  @override
  State<MoneyBotAI> createState() => _MoneyBotAIState();
}

class _MoneyBotAIState extends State<MoneyBotAI> {
  late SharedPreferences prefs;
  bool _showDialog = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController monthlyIncomeController = TextEditingController();
  TextEditingController annualIncomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _showDialog = prefs.getBool('showDialog') ?? true;
    });
  }

  Future<void> _showIncomeInfoSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return IncomeInfoSheet(
          monthlyIncomeController: monthlyIncomeController,
          annualIncomeController: annualIncomeController,
          formKey: _formKey,
          prefs: prefs,
          context: context,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        (context.watch<AppUserCubit>().state as AppUserLoggedIn).user.name;
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
                    InvestmentBox(
                      onTap: () {
                        if (_showDialog) {
                          _showIncomeInfoSheet(context);
                        }
                      },
                    ),
                    Column(
                      children: [
                        AdviceBox(
                          onTap: () {
                            if (_showDialog) {
                              _showIncomeInfoSheet(context);
                            }
                          },
                          color: const Color.fromARGB(255, 128, 97, 136),
                          icon: FontAwesomeIcons.bank,
                          title1: 'Savings',
                          title2: 'Advice',
                        ),
                        SizedBox(
                          height: deviceSize(context).height * 0.026,
                        ),
                        AdviceBox(
                          onTap: () {
                            if (_showDialog) {
                              _showIncomeInfoSheet(context);
                            } else {
                              Navigator.of(context)
                                  .pushNamed(AllFinanceGoals.routeName);
                            }
                          },
                          color: const Color.fromARGB(255, 167, 114, 181),
                          icon: FontAwesomeIcons.moneyBill,
                          title1: 'Finance',
                          title2: 'Goals',
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
                  _showIncomeInfoSheet(context);
                },
                child: Text("Edit Income"),
              ),
              if (prefs.containsKey('monthlyIncome'))
                Text(
                  "${prefs.getString('monthlyIncome')} ₹ / month",
                  style: const TextStyle(
                    color: AppPallete.blackColor,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                  ),
                ),
              if (prefs.containsKey('annualIncome'))
                Text(
                  "${prefs.getString('annualIncome')} ₹ / year",
                  style: const TextStyle(
                    color: AppPallete.blackColor,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
