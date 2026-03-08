class DateTimeFormatter {
  DateTimeFormatter._();

  static String formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day.$month.$year';
  }

  static String formatDateOrToday(
    DateTime value, {
    DateTime? now,
    String todayLabel = 'Today',
  }) {
    final current = now ?? DateTime.now();
    if (_isSameDay(value, current)) {
      return todayLabel;
    }
    return formatDate(value);
  }

  static String formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String formatDateTime(DateTime value) {
    return '${formatDate(value)} ${formatTime(value)}';
  }

  static String formatDateTimeOrToday(
    DateTime value, {
    DateTime? now,
    String todayLabel = 'Today',
  }) {
    return '${formatDateOrToday(value, now: now, todayLabel: todayLabel)} ${formatTime(value)}';
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
