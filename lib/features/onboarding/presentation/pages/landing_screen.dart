import 'package:flutter/material.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_track/features/auth/presentation/pages/login_page.dart';
import 'package:money_track/features/onboarding/presentation/pages/onboarding_creen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0), // Added inner padding
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF8F659A),
              const Color(0xFF8F659A).withOpacity(0.8)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('MoneyTrack',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              const SizedBox(height: 20),
              const Text(
                'Your Personal Expense Tracker',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),
              SvgPicture.asset(
                'assets/svg/landing.svg',
                height: deviceSize(context).height * 0.3,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    bool? hasSeenOnboarding =
                        prefs.getBool('hasSeenOnboarding') ?? false;

                    if (hasSeenOnboarding) {
                      Navigator.of(context).pushNamed(LoginPage.routename);
                    } else {
                      await prefs.setBool('hasSeenOnboarding', true);
                      Navigator.of(context).pushNamed(Onboarding.routename);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    primary: Colors.white,
                    onPrimary: AppPallete.buttonColor,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
