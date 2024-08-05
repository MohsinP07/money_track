import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/features/auth/presentation/widgets/money_bot_ai.dart';

class AiAssistance extends StatefulWidget {
  const AiAssistance({super.key});

  @override
  State<AiAssistance> createState() => _AiAssistanceState();
}

class _AiAssistanceState extends State<AiAssistance> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, MoneyBotAI.routename);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppPallete.boxColor,
          radius: deviceSize(context).width * 0.06,
          child: const Center(
            child: Icon(
              FontAwesomeIcons.robot,
              color: AppPallete.whiteColor,
            ),
          ),
        ),
        title: Text(
          "moneybot_ai".tr,
          style: const TextStyle(fontSize: 12),
        ),
        subtitle: Text(
          'get_suggestions'.tr,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
