import 'package:intl/intl.dart';

class DukaanDateUtils {
  DukaanDateUtils._();

  static String formatOrderDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  static String formatShortDate(DateTime dateTime) {
    return DateFormat('dd MMM, hh:mm a').format(dateTime);
  }
}
