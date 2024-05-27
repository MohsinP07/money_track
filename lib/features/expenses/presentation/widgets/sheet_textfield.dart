// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:money_track/core/themes/app_pallete.dart';

class SheetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const SheetTextField({
    Key? key,
    required this.controller,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: AppPallete.boxColor,
          )),
      validator: (value) {
        if (value!.isEmpty) {
          return "$label is missing!";
        }
        return null;
      },
    );
  }
}
