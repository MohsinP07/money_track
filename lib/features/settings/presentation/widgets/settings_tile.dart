import 'package:flutter/material.dart';
import 'package:money_track/core/constants/global_variables.dart';

class SettingsTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String trailingText;
  final IconData trailingIcon;
  final VoidCallback onTrailingIconPressed;

  const SettingsTile({
    Key? key,
    required this.leadingIcon,
    required this.title,
    required this.trailingText,
    required this.trailingIcon,
    required this.onTrailingIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              leadingIcon,
              size: 20,
            ),
            SizedBox(
              width: deviceSize(context).width * 0.036,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              trailingText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: onTrailingIconPressed,
              icon: Icon(
                trailingIcon,
                size: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
