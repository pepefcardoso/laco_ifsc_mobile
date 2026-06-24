import 'package:intl/intl.dart';

class DateFormatter {
  static String formatRelative(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}
