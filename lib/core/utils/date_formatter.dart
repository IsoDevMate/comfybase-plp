import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y • h:mm a').format(dateTime);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  static String formatDateTimeRange(DateTime start, DateTime end) {
    final dateFormat = DateFormat('MMM d, y');
    final timeFormat = DateFormat('h:mm a');
    
    if (dateFormat.format(start) == dateFormat.format(end)) {
      // Same day, different times
      return '${dateFormat.format(start)} • ${timeFormat.format(start)} - ${timeFormat.format(end)}';
    } else {
      // Different days
      return '${formatDateTime(start)} - ${formatDateTime(end)}';
    }
  }
}
