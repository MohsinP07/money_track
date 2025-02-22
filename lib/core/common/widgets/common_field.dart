import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_track/core/themes/app_pallete.dart';

class CommonTextField extends StatefulWidget {
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
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  Color getDynamicColor() {
    if (!widget.isObscureText) {
      return Colors.black;
    }

    int length = widget.controller.text.length;

    if (length == 3) {
      return Colors.yellow;
    } else if (length < 3) {
      return AppPallete.errorColor;
    } else {
      return Colors.green;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isObscureText) {
      widget.controller.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      cursorColor: getDynamicColor(),
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.leadingIcon,
          color: widget.isObscureText ? getDynamicColor() : null,
        ),
        hintText: widget.hintText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return widget.hintText + "is_missing".tr;
        }
        return null;
      },
      obscureText: widget.isObscureText,
      enabled: widget.isEnable,
    );
  }
}
