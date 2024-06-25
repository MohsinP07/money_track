import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';

class InvestmentBox extends StatelessWidget {
  final VoidCallback onTap;

  const InvestmentBox({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
    );
  }
}
