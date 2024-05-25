// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:money_track/core/themes/app_pallete.dart';

class ExpenseTile extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String amount;
  final String date;
  const ExpenseTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: AppPallete.greyColor,
            borderRadius: BorderRadius.circular(10),
          ),
          height: deviceSize(context).height * 0.08,
          width: deviceSize(context).width * 0.14,
          child: Image.asset(icon),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: SizedBox(
          height: deviceSize(context).height * 0.08,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
