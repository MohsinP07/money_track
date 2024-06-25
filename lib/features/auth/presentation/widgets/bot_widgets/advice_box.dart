import 'package:flutter/material.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';

class AdviceBox extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final IconData icon;
  final String title1;
  final String title2;

  const AdviceBox({
    required this.onTap,
    required this.color,
    required this.icon,
    required this.title1,
    required this.title2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: deviceSize(context).height * 0.13,
        width: deviceSize(context).width * 0.34,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppPallete.whiteColor,
              size: 18,
            ),
            SizedBox(
              height: deviceSize(context).height * 0.01,
            ),
            RichText(
              maxLines: 3,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title1\n',
                    style: const TextStyle(
                      color: AppPallete.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextSpan(
                    text: title2,
                    style: const TextStyle(
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
    );
  }
}
