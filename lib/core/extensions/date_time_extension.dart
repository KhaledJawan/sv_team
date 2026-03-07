import '../utils/date_time_formatter.dart';

extension DateTimeExtension on DateTime {
  String get hhMm => DateTimeFormatter.formatTime(this);
}
