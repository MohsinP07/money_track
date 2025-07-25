import 'package:flutter/material.dart';
import 'package:money_track/core/themes/app_pallete.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color; // Text color
  final Color? bgColor; // Background color
  final double height;
  final double width;
  final double borderRadius;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.bgColor = AppPallete.borderColor,
    this.height = 48,
    this.width = double.infinity,
    this.borderRadius = 16,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: color ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 4,
          shadowColor: AppPallete.borderColor.withOpacity(0.09),
          textStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
            letterSpacing: 0.2,
          ),
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}
