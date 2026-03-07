import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/date_time_extension.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../../../models/derived_item.dart';
import '../../../models/drink_order_item.dart';
import '../../../models/task_category.dart';
import '../../../models/task_item.dart';
import '../../../models/task_status.dart';

class TasksNotifier extends Notifier<List<TaskItem>> {
  @override
  List<TaskItem> build() => [..._sampleTasks]..sort(_byPrepareTime);

  void addTask(TaskItem task) {
    final updated = [...state, task]..sort(_byPrepareTime);
    state = updated;
    _pushNotification(
      title: 'Task added',
      message:
          '${task.roomName} · ${task.category.label} · Prep ${task.prepareTime.hhMm}',
    );
  }

  void updateTaskStatus({required String taskId, required TaskStatus status}) {
    final previousTask = _findTaskById(taskId);
    final updated = [
      for (final task in state)
        if (task.id == taskId) task.copyWith(status: status) else task,
    ]..sort(_byPrepareTime);
    state = updated;

    if (previousTask != null && previousTask.status != status) {
      _pushNotification(
        title: 'Task status changed',
        message:
            '${previousTask.roomName} changed from ${previousTask.status.label} to ${status.label}.',
      );
    }
  }

  void updateTask(TaskItem updatedTask) {
    final previousTask = _findTaskById(updatedTask.id);
    final updated = [
      for (final task in state)
        if (task.id == updatedTask.id) updatedTask else task,
    ]..sort(_byPrepareTime);
    state = updated;

    final suffix =
        previousTask != null && previousTask.status != updatedTask.status
        ? ' Status: ${updatedTask.status.label}.'
        : '';
    _pushNotification(
      title: 'Task updated',
      message: '${updatedTask.roomName} was updated.$suffix',
    );
  }

  void deleteTask(String taskId) {
    final deletedTask = _findTaskById(taskId);
    state = [
      for (final task in state)
        if (task.id != taskId) task,
    ]..sort(_byPrepareTime);

    if (deletedTask != null) {
      _pushNotification(
        title: 'Task deleted',
        message:
            '${deletedTask.roomName} · ${deletedTask.category.label} was deleted.',
      );
    }
  }

  int _byPrepareTime(TaskItem a, TaskItem b) {
    final byClockTime = _minutesOfDay(
      a.prepareTime,
    ).compareTo(_minutesOfDay(b.prepareTime));
    if (byClockTime != 0) {
      return byClockTime;
    }
    return a.prepareTime.compareTo(b.prepareTime);
  }

  int _minutesOfDay(DateTime value) {
    return (value.hour * 60) + value.minute;
  }

  void _pushNotification({required String title, required String message}) {
    ref
        .read(notificationsProvider.notifier)
        .push(title: title, message: message);
  }

  TaskItem? _findTaskById(String taskId) {
    for (final task in state) {
      if (task.id == taskId) {
        return task;
      }
    }
    return null;
  }
}

final tasksProvider = NotifierProvider<TasksNotifier, List<TaskItem>>(
  TasksNotifier.new,
);

final sortedTasksProvider = Provider<List<TaskItem>>((ref) {
  final tasks = [...ref.watch(tasksProvider)];
  tasks.sort((a, b) {
    final byClockTime = ((a.prepareTime.hour * 60) + a.prepareTime.minute)
        .compareTo((b.prepareTime.hour * 60) + b.prepareTime.minute);
    if (byClockTime != 0) {
      return byClockTime;
    }
    return a.prepareTime.compareTo(b.prepareTime);
  });
  return tasks;
});

final _sampleTasks = <TaskItem>[
  TaskItem(
    id: 'sample_drinks_1',
    roomName: 'Room 002',
    prepareTime: DateTime(2026, 3, 7, 9, 30),
    collectTime: DateTime(2026, 3, 7, 10, 0),
    category: TaskCategory.drinks,
    personsCount: 8,
    orderedDrinks: const [
      DrinkOrderItem(id: 'coffee', name: 'Coffee', quantity: 1),
      DrinkOrderItem(id: 'water', name: 'Water', quantity: 8),
    ],
    derivedItems: const [
      DerivedItem(id: 'cups', name: 'Cups', quantity: 8),
      DerivedItem(id: 'saucers', name: 'Saucers', quantity: 8),
      DerivedItem(id: 'napkins', name: 'Napkins', quantity: 8),
      DerivedItem(id: 'glasses', name: 'Glasses', quantity: 8),
    ],
    shortDescription: '1 Coffee · 8 Water · 8 persons',
    note: null,
    status: TaskStatus.pending,
    createdAt: DateTime(2026, 3, 7, 8, 20),
  ),
  TaskItem(
    id: 'sample_food_1',
    roomName: 'Room 004',
    prepareTime: DateTime(2026, 3, 7, 10, 15),
    collectTime: DateTime(2026, 3, 7, 10, 45),
    category: TaskCategory.foodSetup,
    personsCount: 12,
    orderedDrinks: const [
      DrinkOrderItem(id: 'plates', name: 'Plates', quantity: 12),
      DrinkOrderItem(id: 'forks', name: 'Forks', quantity: 12),
      DrinkOrderItem(id: 'knives', name: 'Knives', quantity: 12),
      DrinkOrderItem(id: 'napkins', name: 'Napkins', quantity: 12),
    ],
    derivedItems: const [],
    shortDescription: 'Food setup · 12 persons · 12 Plates · 12 Forks',
    note: null,
    status: TaskStatus.pending,
    createdAt: DateTime(2026, 3, 7, 8, 25),
  ),
  TaskItem(
    id: 'sample_drinks_2',
    roomName: 'Room 007',
    prepareTime: DateTime(2026, 3, 7, 11, 0),
    collectTime: DateTime(2026, 3, 7, 11, 35),
    category: TaskCategory.drinks,
    personsCount: 10,
    orderedDrinks: const [
      DrinkOrderItem(id: 'coca_cola', name: 'Coca-Cola', quantity: 10),
      DrinkOrderItem(id: 'tea', name: 'Tea', quantity: 2),
    ],
    derivedItems: const [
      DerivedItem(id: 'cups', name: 'Cups', quantity: 10),
      DerivedItem(id: 'napkins', name: 'Napkins', quantity: 10),
      DerivedItem(id: 'glasses', name: 'Glasses', quantity: 10),
    ],
    shortDescription: '10 Coca-Cola · 2 Tea · 10 persons',
    note: null,
    status: TaskStatus.done,
    createdAt: DateTime(2026, 3, 7, 8, 30),
  ),
  TaskItem(
    id: 'sample_note_1',
    roomName: 'Room 001',
    prepareTime: DateTime(2026, 3, 7, 12, 0),
    collectTime: DateTime(2026, 3, 7, 12, 20),
    category: TaskCategory.note,
    personsCount: null,
    orderedDrinks: const [],
    derivedItems: const [],
    shortDescription: 'VIP request',
    note: 'Please prepare extra quiet service and keep sparkling water ready.',
    status: TaskStatus.pending,
    createdAt: DateTime(2026, 3, 7, 8, 35),
  ),
  TaskItem(
    id: 'sample_food_2',
    roomName: 'Room 009',
    prepareTime: DateTime(2026, 3, 7, 13, 15),
    collectTime: DateTime(2026, 3, 7, 13, 50),
    category: TaskCategory.foodSetup,
    personsCount: 16,
    orderedDrinks: const [
      DrinkOrderItem(id: 'bowls', name: 'Bowls', quantity: 16),
      DrinkOrderItem(id: 'small_spoons', name: 'Small spoons', quantity: 16),
      DrinkOrderItem(id: 'glasses', name: 'Glasses', quantity: 16),
    ],
    derivedItems: const [],
    shortDescription: 'Food setup · 16 persons · 16 Bowls · 16 Small spoons',
    note: null,
    status: TaskStatus.problem,
    createdAt: DateTime(2026, 3, 7, 8, 45),
  ),
  TaskItem(
    id: 'sample_drinks_3',
    roomName: 'Room 010',
    prepareTime: DateTime(2026, 3, 7, 14, 30),
    collectTime: DateTime(2026, 3, 7, 15, 0),
    category: TaskCategory.drinks,
    personsCount: 20,
    orderedDrinks: const [
      DrinkOrderItem(id: 'fanta', name: 'Fanta', quantity: 12),
      DrinkOrderItem(id: 'juice', name: 'Juice', quantity: 8),
    ],
    derivedItems: const [
      DerivedItem(id: 'glasses', name: 'Glasses', quantity: 20),
    ],
    shortDescription: '12 Fanta · 8 Juice · 20 persons',
    note: null,
    status: TaskStatus.pending,
    createdAt: DateTime(2026, 3, 7, 8, 50),
  ),
];
