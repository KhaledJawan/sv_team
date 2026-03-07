import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../models/app_notification_item.dart';

class NotificationsNotifier extends Notifier<List<AppNotificationItem>> {
  @override
  List<AppNotificationItem> build() => const [];

  void push({
    required String title,
    required String message,
    String? actorName,
  }) {
    final notification = AppNotificationItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      message: message,
      actorName: actorName ?? AppConstants.currentOperatorName,
      createdAt: DateTime.now(),
      isRead: false,
    );
    state = [notification, ...state];
  }

  void markAllRead() {
    state = [
      for (final notification in state)
        if (notification.isRead)
          notification
        else
          notification.copyWith(isRead: true),
    ];
  }

  void delete(String id) {
    state = [
      for (final notification in state)
        if (notification.id != id) notification,
    ];
  }

  void clearAll() {
    state = const [];
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<AppNotificationItem>>(
      NotificationsNotifier.new,
    );

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((item) => !item.isRead).length;
});

final hasUnreadNotificationsProvider = Provider<bool>((ref) {
  return ref.watch(unreadNotificationsCountProvider) > 0;
});
