import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String amount;
  final String date;
  final VoidCallback? onLongPress;

  const ExpenseTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: ListTile(
        leading: Image.asset(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount),
            Text(date),
          ],
        ),
      ),
    );
  }
}
