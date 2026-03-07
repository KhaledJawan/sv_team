import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/derived_item.dart';
import '../../../models/drink_order_item.dart';
import '../../../models/task_category.dart';
import '../../../models/task_item.dart';
import '../../../models/task_status.dart';

class TasksNotifier extends Notifier<List<TaskItem>> {
  @override
  List<TaskItem> build() => [..._sampleTasks]..sort(_byScheduledTime);

  void addTask(TaskItem task) {
    final updated = [...state, task]..sort(_byScheduledTime);
    state = updated;
  }

  void updateTaskStatus({required String taskId, required TaskStatus status}) {
    final updated = [
      for (final task in state)
        if (task.id == taskId) task.copyWith(status: status) else task,
    ]..sort(_byScheduledTime);
    state = updated;
  }

  void updateTask(TaskItem updatedTask) {
    final updated = [
      for (final task in state)
        if (task.id == updatedTask.id) updatedTask else task,
    ]..sort(_byScheduledTime);
    state = updated;
  }

  void deleteTask(String taskId) {
    state = [
      for (final task in state)
        if (task.id != taskId) task,
    ]..sort(_byScheduledTime);
  }

  int _byScheduledTime(TaskItem a, TaskItem b) {
    final byClockTime = _minutesOfDay(
      a.scheduledTime,
    ).compareTo(_minutesOfDay(b.scheduledTime));
    if (byClockTime != 0) {
      return byClockTime;
    }
    return a.scheduledTime.compareTo(b.scheduledTime);
  }

  int _minutesOfDay(DateTime value) {
    return (value.hour * 60) + value.minute;
  }
}

final tasksProvider = NotifierProvider<TasksNotifier, List<TaskItem>>(
  TasksNotifier.new,
);

final sortedTasksProvider = Provider<List<TaskItem>>((ref) {
  final tasks = [...ref.watch(tasksProvider)];
  tasks.sort((a, b) {
    final byClockTime = ((a.scheduledTime.hour * 60) + a.scheduledTime.minute)
        .compareTo((b.scheduledTime.hour * 60) + b.scheduledTime.minute);
    if (byClockTime != 0) {
      return byClockTime;
    }
    return a.scheduledTime.compareTo(b.scheduledTime);
  });
  return tasks;
});

final _sampleTasks = <TaskItem>[
  TaskItem(
    id: 'sample_drinks_1',
    roomName: 'Room 002',
    scheduledTime: DateTime(2026, 3, 7, 9, 30),
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
    scheduledTime: DateTime(2026, 3, 7, 10, 15),
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
    scheduledTime: DateTime(2026, 3, 7, 11, 0),
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
    scheduledTime: DateTime(2026, 3, 7, 12, 0),
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
    scheduledTime: DateTime(2026, 3, 7, 13, 15),
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
    scheduledTime: DateTime(2026, 3, 7, 14, 30),
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
