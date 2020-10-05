import 'package:intl/intl.dart';

final numFormat = NumberFormat("%", "en_US");

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String percent(int num) {
    return numFormat.format(num);
  }
}