import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final IconData leadingIcon;
  final bool isEnable;
  final TextInputType? keyboardType;

  const CommonTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.leadingIcon = Icons.text_fields_rounded,
    this.isEnable = true,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(
          leadingIcon,
        ),
        hintText: hintText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return hintText + "is_missing".tr;
        }
        return null;
      },
      obscureText: isObscureText,
      enabled: isEnable,
    );
  }
}
