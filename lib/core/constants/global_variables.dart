import 'package:flutter/material.dart';

String uri = 'https://money-track-8gsw.onrender.com';

Size deviceSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

class GlobalVariables {
  // COLORS
  static LinearGradient appBarGradient = LinearGradient(
    colors: [Colors.lightBlue.shade300, Colors.teal.shade100],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryColor = Color.fromARGB(255, 76, 168, 196);
  static const secondaryColorCollab = Color(0xFF0CE6DF);
  static const secondaryColorLight = Color.fromRGBO(255, 153, 0, 1);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static var selectedNavBarColor = Color(0xFF42224A);
  static const unselectedNavBarColor = Colors.black87;
}
