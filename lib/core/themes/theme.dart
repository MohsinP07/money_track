import 'package:flutter/material.dart';
import 'package:money_track/core/themes/app_pallete.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(10));
  static final themeMode = ThemeData(
    scaffoldBackgroundColor: AppPallete.whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.whiteColor,
    ),
    fontFamily: 'Poppins',
    chipTheme: const ChipThemeData(
      backgroundColor: AppPallete.whiteColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: AppPallete.boxColor,
      contentPadding: const EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.boxColor),
      errorBorder: _border(AppPallete.errorColor),
      disabledBorder: _border(AppPallete.buttonColor),
    ),
  );
}
