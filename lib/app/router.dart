import 'package:flutter/material.dart';

import '../features/aufgaben/aufgaben_screen.dart';
import '../features/aufgaben/task_detail_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/shell/shell_screen.dart';
import '../models/task_item.dart';

class AppRouter {
  AppRouter._();

  static const shell = '/';
  static const aufgaben = '/aufgaben';
  static const taskDetail = '/task-detail';
  static const notifications = '/notifications';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case shell:
        return MaterialPageRoute<void>(
          builder: (_) => const ShellScreen(),
          settings: settings,
        );
      case aufgaben:
        return MaterialPageRoute<void>(
          builder: (_) => const AufgabenScreen(),
          settings: settings,
        );
      case taskDetail:
        final task = settings.arguments;
        if (task is TaskItem) {
          return MaterialPageRoute<void>(
            builder: (_) => TaskDetailScreen(task: task),
            settings: settings,
          );
        }
        return _fallbackRoute();
      case notifications:
        return MaterialPageRoute<void>(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );
      default:
        return _fallbackRoute();
    }
  }

  static Route<dynamic> _fallbackRoute() {
    return MaterialPageRoute<void>(builder: (_) => const ShellScreen());
  }
}
