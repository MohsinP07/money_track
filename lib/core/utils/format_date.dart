import 'package:intl/intl.dart';

String formatDatedMMMYYYY(DateTime dateTime) {
  return DateFormat("d MMM, yyyy").format(dateTime).toString();
}
