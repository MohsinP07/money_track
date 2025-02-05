// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:money_track/core/themes/app_pallete.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? bgColor;
  const CustomButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.color,
      this.bgColor = AppPallete.borderColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(color: color == null ? Colors.white : Colors.black),
      ),
      style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50), primary: bgColor),
    );
  }
}
