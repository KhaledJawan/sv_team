import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/date_time_extension.dart';
import '../data/task_local_repository.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../../../models/task_category.dart';
import '../../../models/task_item.dart';
import '../../../models/task_status.dart';

class TasksNotifier extends Notifier<List<TaskItem>> {
  Timer? _dailySyncTimer;

  @override
  List<TaskItem> build() {
    _dailySyncTimer?.cancel();
    _dailySyncTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      syncRecurringTasksForToday();
    });
    ref.onDispose(() {
      _dailySyncTimer?.cancel();
      _dailySyncTimer = null;
    });

    final repository = ref.read(taskLocalRepositoryProvider);
    final persistedTasks = repository.loadTasks();
    final initial = _withDailySnackDefaults(
      source: [...persistedTasks],
      now: DateTime.now(),
    )..sort(_byTaskSortTime);

    if (!_hasSameSnapshot(persistedTasks, initial)) {
      unawaited(repository.saveTasks(initial));
    }

    return initial;
  }

  void addTask(TaskItem task) {
    syncRecurringTasksForToday();
    final updated = [...state, task]..sort(_byTaskSortTime);
    state = updated;
    _persistState();
    _pushNotification(
      title: 'Task added',
      message:
          '${task.roomName} · ${task.category.label} · Prep ${task.prepareTime.hhMm}',
    );
  }

  void updateTaskStatus({required String taskId, required TaskStatus status}) {
    syncRecurringTasksForToday();
    final previousTask = _findTaskById(taskId);
    final updated = [
      for (final task in state)
        if (task.id == taskId) task.copyWith(status: status) else task,
    ]..sort(_byTaskSortTime);
    state = updated;
    _persistState();

    if (previousTask != null && previousTask.status != status) {
      _pushNotification(
        title: 'Task status changed',
        message:
            '${previousTask.roomName} changed from ${previousTask.status.label} to ${status.label}.',
      );
    }
  }

  void updateTask(TaskItem updatedTask) {
    syncRecurringTasksForToday();
    final previousTask = _findTaskById(updatedTask.id);
    final updated = [
      for (final task in state)
        if (task.id == updatedTask.id) updatedTask else task,
    ]..sort(_byTaskSortTime);
    state = updated;
    _persistState();

    final suffix =
        previousTask != null && previousTask.status != updatedTask.status
        ? ' Status: ${updatedTask.status.label}.'
        : '';
    _pushNotification(
      title: 'Task updated',
      message: '${updatedTask.roomName} was updated.$suffix',
    );
  }

  bool deleteTask(String taskId) {
    syncRecurringTasksForToday();
    if (_dailySnackTaskIds.contains(taskId)) {
      _pushNotification(
        title: 'Task kept',
        message:
            'Daily snack-machine tasks are recurring and cannot be deleted.',
      );
      return false;
    }

    final deletedTask = _findTaskById(taskId);
    state = [
      for (final task in state)
        if (task.id != taskId) task,
    ]..sort(_byTaskSortTime);
    _persistState();

    if (deletedTask != null) {
      _pushNotification(
        title: 'Task deleted',
        message:
            '${deletedTask.roomName} · ${deletedTask.category.label} was deleted.',
      );
      return true;
    }
    return false;
  }

  void syncRecurringTasksForToday() {
    final synced = _withDailySnackDefaults(source: state, now: DateTime.now())
      ..sort(_byTaskSortTime);
    if (!_hasSameSnapshot(state, synced)) {
      state = synced;
      _persistState();
    }
  }

  int _byTaskSortTime(TaskItem a, TaskItem b) {
    return compareTasksByOperationalTime(a, b);
  }

  void _pushNotification({required String title, required String message}) {
    ref
        .read(notificationsProvider.notifier)
        .push(title: title, message: message);
  }

  void _persistState() {
    unawaited(ref.read(taskLocalRepositoryProvider).saveTasks(state));
  }

  TaskItem? _findTaskById(String taskId) {
    for (final task in state) {
      if (task.id == taskId) {
        return task;
      }
    }
    return null;
  }

  List<TaskItem> _withDailySnackDefaults({
    required List<TaskItem> source,
    required DateTime now,
  }) {
    final byId = <String, TaskItem>{for (final task in source) task.id: task};
    final today = DateTime(now.year, now.month, now.day);

    for (final template in _dailySnackTaskTemplates) {
      final existing = byId[template.id];
      final keepStatus =
          existing != null && _isSameDay(existing.prepareTime, today)
          ? existing.status
          : TaskStatus.pending;
      final keepCreatedAt =
          existing != null && _isSameDay(existing.prepareTime, today)
          ? existing.createdAt
          : now;
      byId[template.id] = template.toTaskForDay(
        day: today,
        status: keepStatus,
        createdAt: keepCreatedAt,
      );
    }

    return byId.values.toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _hasSameSnapshot(List<TaskItem> before, List<TaskItem> after) {
    if (before.length != after.length) {
      return false;
    }
    final beforeSnapshot = before.map(_taskSnapshot).toList();
    final afterSnapshot = after.map(_taskSnapshot).toList();
    return listEquals(beforeSnapshot, afterSnapshot);
  }

  String _taskSnapshot(TaskItem task) {
    final ordered = task.orderedDrinks
        .map((item) => '${item.id}:${item.name}:${item.quantity}')
        .join(',');
    final derived = task.derivedItems
        .map((item) => '${item.id}:${item.name}:${item.quantity}')
        .join(',');
    return [
      task.id,
      task.roomName,
      task.prepareTime.millisecondsSinceEpoch,
      task.collectTime.millisecondsSinceEpoch,
      task.category.name,
      task.personsCount ?? -1,
      ordered,
      derived,
      task.shortDescription,
      task.note ?? '',
      task.status.name,
      task.createdAt.millisecondsSinceEpoch,
    ].join('|');
  }
}

final tasksProvider = NotifierProvider<TasksNotifier, List<TaskItem>>(
  TasksNotifier.new,
);

final sortedTasksProvider = Provider<List<TaskItem>>((ref) {
  final tasks = [...ref.watch(tasksProvider)];
  tasks.sort(compareTasksByOperationalTime);
  return tasks;
});

int compareTasksByOperationalTime(TaskItem a, TaskItem b) {
  final timeA = _timeUsedForSorting(a);
  final timeB = _timeUsedForSorting(b);

  final now = DateTime.now();
  final aIsToday = _isSameCalendarDay(timeA, now);
  final bIsToday = _isSameCalendarDay(timeB, now);
  if (aIsToday != bIsToday) {
    return aIsToday ? -1 : 1;
  }

  final byDate = _dateOnly(timeA).compareTo(_dateOnly(timeB));
  if (byDate != 0) {
    return byDate;
  }

  return timeA.compareTo(timeB);
}

DateTime _timeUsedForSorting(TaskItem task) {
  return task.status == TaskStatus.prepared
      ? task.collectTime
      : task.prepareTime;
}

bool _isSameCalendarDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

const _dailySnackTaskIds = <String>{
  'default_snack_machine_0600',
  'default_snack_machine_1000',
};

const _dailySnackTaskTemplates = <_DailySnackTaskTemplate>[
  _DailySnackTaskTemplate(
    id: 'default_snack_machine_0600',
    hour: 6,
    minute: 0,
    shortDescription: 'Refill snack machines (morning round).',
  ),
  _DailySnackTaskTemplate(
    id: 'default_snack_machine_1000',
    hour: 10,
    minute: 0,
    shortDescription: 'Refill snack machines (late morning round).',
  ),
];

class _DailySnackTaskTemplate {
  const _DailySnackTaskTemplate({
    required this.id,
    required this.hour,
    required this.minute,
    required this.shortDescription,
  });

  final String id;
  final int hour;
  final int minute;
  final String shortDescription;

  TaskItem toTaskForDay({
    required DateTime day,
    required TaskStatus status,
    required DateTime createdAt,
  }) {
    final prepareTime = DateTime(day.year, day.month, day.day, hour, minute);

    return TaskItem(
      id: id,
      roomName: 'Snack Machines',
      prepareTime: prepareTime,
      collectTime: prepareTime,
      category: TaskCategory.snacky,
      personsCount: null,
      orderedDrinks: const [],
      derivedItems: const [],
      shortDescription: shortDescription,
      note: 'Refill all vending machines with snacks.',
      status: status,
      createdAt: createdAt,
    );
  }
}
