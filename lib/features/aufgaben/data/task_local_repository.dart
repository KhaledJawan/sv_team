import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/storage/hive_storage.dart';
import '../../../models/derived_item.dart';
import '../../../models/drink_order_item.dart';
import '../../../models/task_category.dart';
import '../../../models/task_item.dart';
import '../../../models/task_status.dart';

const _tasksStorageKey = 'tasks_json';

final taskLocalRepositoryProvider = Provider<TaskLocalRepository>((ref) {
  return TaskLocalRepository(box: HiveStorage.tasksBox());
});

class TaskLocalRepository {
  const TaskLocalRepository({required this.box});

  final Box<String> box;

  List<TaskItem> loadTasks() {
    final raw = box.get(_tasksStorageKey);
    if (raw == null || raw.isEmpty) {
      return const <TaskItem>[];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const <TaskItem>[];
      }

      return decoded
          .whereType<Map>()
          .map((entry) => _taskFromMap(Map<String, dynamic>.from(entry)))
          .whereType<TaskItem>()
          .toList();
    } catch (_) {
      return const <TaskItem>[];
    }
  }

  Future<void> saveTasks(List<TaskItem> tasks) {
    final payload = tasks.map(_taskToMap).toList();
    return box.put(_tasksStorageKey, jsonEncode(payload));
  }

  Map<String, dynamic> _taskToMap(TaskItem task) {
    return <String, dynamic>{
      'id': task.id,
      'roomName': task.roomName,
      'prepareTimeMs': task.prepareTime.millisecondsSinceEpoch,
      'collectTimeMs': task.collectTime.millisecondsSinceEpoch,
      'category': task.category.name,
      'personsCount': task.personsCount,
      'orderedDrinks': task.orderedDrinks
          .map(
            (item) => <String, dynamic>{
              'id': item.id,
              'name': item.name,
              'quantity': item.quantity,
            },
          )
          .toList(),
      'derivedItems': task.derivedItems
          .map(
            (item) => <String, dynamic>{
              'id': item.id,
              'name': item.name,
              'quantity': item.quantity,
            },
          )
          .toList(),
      'shortDescription': task.shortDescription,
      'note': task.note,
      'status': task.status.name,
      'createdAtMs': task.createdAt.millisecondsSinceEpoch,
    };
  }

  TaskItem? _taskFromMap(Map<String, dynamic> map) {
    final id = _asString(map['id']);
    final roomName = _asString(map['roomName']);
    final prepareTimeMs = _asInt(map['prepareTimeMs']);
    final collectTimeMs = _asInt(map['collectTimeMs']);
    final shortDescription = _asString(map['shortDescription']);
    final createdAtMs = _asInt(map['createdAtMs']);

    if (id == null ||
        roomName == null ||
        prepareTimeMs == null ||
        collectTimeMs == null ||
        shortDescription == null ||
        createdAtMs == null) {
      return null;
    }

    final category = _categoryFromName(map['category']);
    final status = _statusFromName(map['status']);
    final personsCount = _asInt(map['personsCount']);

    final orderedDrinks = _asList(map['orderedDrinks'])
        .map((entry) => _drinkOrderItemFromMap(_asMap(entry)))
        .whereType<DrinkOrderItem>()
        .toList();

    final derivedItems = _asList(map['derivedItems'])
        .map((entry) => _derivedItemFromMap(_asMap(entry)))
        .whereType<DerivedItem>()
        .toList();

    return TaskItem(
      id: id,
      roomName: roomName,
      prepareTime: DateTime.fromMillisecondsSinceEpoch(prepareTimeMs),
      collectTime: DateTime.fromMillisecondsSinceEpoch(collectTimeMs),
      category: category,
      personsCount: personsCount,
      orderedDrinks: orderedDrinks,
      derivedItems: derivedItems,
      shortDescription: shortDescription,
      note: _asNullableString(map['note']),
      status: status,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
    );
  }

  DrinkOrderItem? _drinkOrderItemFromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }

    final id = _asString(map['id']);
    final name = _asString(map['name']);
    final quantity = _asInt(map['quantity']);
    if (id == null || name == null || quantity == null) {
      return null;
    }

    return DrinkOrderItem(id: id, name: name, quantity: quantity);
  }

  DerivedItem? _derivedItemFromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }

    final id = _asString(map['id']);
    final name = _asString(map['name']);
    final quantity = _asInt(map['quantity']);
    if (id == null || name == null || quantity == null) {
      return null;
    }

    return DerivedItem(id: id, name: name, quantity: quantity);
  }

  TaskCategory _categoryFromName(dynamic raw) {
    final value = _asString(raw);
    if (value == null) {
      return TaskCategory.others;
    }

    for (final category in TaskCategory.values) {
      if (category.name == value) {
        return category;
      }
    }
    return TaskCategory.others;
  }

  TaskStatus _statusFromName(dynamic raw) {
    final value = _asString(raw);
    if (value == null) {
      return TaskStatus.pending;
    }

    for (final status in TaskStatus.values) {
      if (status.name == value) {
        return status;
      }
    }
    return TaskStatus.pending;
  }

  List<dynamic> _asList(dynamic raw) {
    return raw is List ? raw : const <dynamic>[];
  }

  Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }

  String? _asString(dynamic raw) {
    if (raw is String) {
      final trimmed = raw.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }

  String? _asNullableString(dynamic raw) {
    if (raw == null) {
      return null;
    }
    if (raw is String) {
      return raw;
    }
    return null;
  }

  int? _asInt(dynamic raw) {
    if (raw is int) {
      return raw;
    }
    if (raw is num) {
      return raw.toInt();
    }
    if (raw is String) {
      return int.tryParse(raw.trim());
    }
    return null;
  }
}
