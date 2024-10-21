import 'package:flutter/material.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/themes/app_pallete.dart';

class GoalBox extends StatelessWidget {
  const GoalBox(
      {super.key,
      required this.deviceSize,
      required this.image,
      required this.title,
      required this.onPressed});

  final Size deviceSize;
  final String image;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceSize.width * 0.4,
      height: deviceSize.height * 0.26,
      decoration: BoxDecoration(
        border: Border.all(color: AppPallete.borderColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            image,
            height: 80,
            width: 80,
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Card(
              elevation: 6,
              child: CustomButton(
                text: "Create",
                onTap: onPressed,
              ),
            ),
          )
        ],
      ),
    );
  }
}
