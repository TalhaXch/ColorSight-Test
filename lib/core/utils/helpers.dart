import 'package:intl/intl.dart';

class Helpers {
  /// Format date to readable string
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }

  /// Format date to short string
  static String formatDateShort(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Calculate percentage
  static double calculatePercentage(int correct, int total) {
    if (total == 0) return 0.0;
    return (correct / total) * 100;
  }

  /// Get percentage string
  static String getPercentageString(int correct, int total) {
    final percentage = calculatePercentage(correct, total);
    return '${percentage.toStringAsFixed(1)}%';
  }
}
