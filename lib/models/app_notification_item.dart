class AppNotificationItem {
  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.actorName,
    required this.createdAt,
    required this.isRead,
  });

  final String id;
  final String title;
  final String message;
  final String actorName;
  final DateTime createdAt;
  final bool isRead;

  AppNotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    String? actorName,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      actorName: actorName ?? this.actorName,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
