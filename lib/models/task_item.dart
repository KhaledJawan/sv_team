import 'derived_item.dart';
import 'drink_order_item.dart';
import 'task_category.dart';
import 'task_status.dart';

class TaskItem {
  const TaskItem({
    required this.id,
    required this.roomName,
    required this.prepareTime,
    required this.collectTime,
    required this.category,
    required this.personsCount,
    required this.orderedDrinks,
    required this.derivedItems,
    required this.shortDescription,
    required this.status,
    required this.createdAt,
    this.note,
  });

  final String id;
  final String roomName;
  final DateTime prepareTime;
  final DateTime collectTime;
  final TaskCategory category;
  final int? personsCount;
  final List<DrinkOrderItem> orderedDrinks;
  final List<DerivedItem> derivedItems;
  final String shortDescription;
  final String? note;
  final TaskStatus status;
  final DateTime createdAt;

  TaskItem copyWith({
    String? id,
    String? roomName,
    DateTime? prepareTime,
    DateTime? collectTime,
    TaskCategory? category,
    int? personsCount,
    List<DrinkOrderItem>? orderedDrinks,
    List<DerivedItem>? derivedItems,
    String? shortDescription,
    String? note,
    TaskStatus? status,
    DateTime? createdAt,
  }) {
    return TaskItem(
      id: id ?? this.id,
      roomName: roomName ?? this.roomName,
      prepareTime: prepareTime ?? this.prepareTime,
      collectTime: collectTime ?? this.collectTime,
      category: category ?? this.category,
      personsCount: personsCount ?? this.personsCount,
      orderedDrinks: orderedDrinks ?? this.orderedDrinks,
      derivedItems: derivedItems ?? this.derivedItems,
      shortDescription: shortDescription ?? this.shortDescription,
      note: note ?? this.note,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
