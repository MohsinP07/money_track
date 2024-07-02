import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:money_track/core/utils/format_date.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String formattedTime = DateFormat('hh:mm').format(DateTime.now());
  String formattedDate =
      formatDatedMMMYYYY(DateTime.parse(DateTime.now().toString()));
  String hour = DateFormat('a').format(DateTime.now());
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) => _update());
  }

  void _update() {
    if (mounted) {
      setState(() {
        formattedTime = DateFormat('hh:mm').format(DateTime.now());
        hour = DateFormat('a').format(DateTime.now());
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('$formattedDate - ',
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: AppPallete.borderColor,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 2.0)),
                Text(formattedTime,
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: AppPallete.borderColor,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 2.0)),
                Text(
                  hour,
                  style: const TextStyle(
                    color: AppPallete.buttonColor,
                    fontSize: 8.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
