import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/widgets/money_bot_ai.dart';

class AiAssistance extends StatelessWidget {
  const AiAssistance({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, MoneyBotAI.routename);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppPallete.boxColor,
              radius: deviceSize(context).width * 0.06,
              child: const Icon(
                FontAwesomeIcons.robot,
                color: AppPallete.whiteColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "moneybot_ai".tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppPallete.blackColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "get_suggestions".tr,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppPallete.boxColor,
            )
          ],
        ),
      ),
    );
  }
}
