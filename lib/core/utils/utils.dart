import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(title),
    duration: const Duration(seconds: 2),
  ));
}
