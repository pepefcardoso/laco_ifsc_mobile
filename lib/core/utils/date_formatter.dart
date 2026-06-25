import 'package:intl/intl.dart';

class DateFormatter {
  static String formatRelative(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'há ${diff.inHours} hora${diff.inHours > 1 ? "s" : ""}';
    if (diff.inDays < 7) return 'há ${diff.inDays} dia${diff.inDays > 1 ? "s" : ""}';
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}
