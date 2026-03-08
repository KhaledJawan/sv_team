import '../utils/date_time_formatter.dart';

extension DateTimeExtension on DateTime {
  String get ddMmYyyy => DateTimeFormatter.formatDate(this);
  String get ddMmYyyyOrToday => DateTimeFormatter.formatDateOrToday(this);
  String ddMmYyyyOrTodayLabel(String todayLabel) =>
      DateTimeFormatter.formatDateOrToday(this, todayLabel: todayLabel);
  String get hhMm => DateTimeFormatter.formatTime(this);
  String get ddMmYyyyHhMm => DateTimeFormatter.formatDateTime(this);
  String get ddMmYyyyOrTodayHhMm =>
      DateTimeFormatter.formatDateTimeOrToday(this);
  String ddMmYyyyOrTodayHhMmLabel(String todayLabel) =>
      DateTimeFormatter.formatDateTimeOrToday(this, todayLabel: todayLabel);
}
