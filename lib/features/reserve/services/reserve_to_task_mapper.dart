import '../../../core/constants/app_constants.dart';
import '../../../models/derived_item.dart';
import '../../../models/drink_order_item.dart';
import '../../../models/task_category.dart';
import '../../../models/task_item.dart';
import '../../../models/task_status.dart';

class DrinksReserveInput {
  const DrinksReserveInput({
    required this.roomName,
    required this.prepareTime,
    required this.collectTime,
    required this.personsCount,
    required this.drinkQuantities,
  });

  final String roomName;
  final DateTime prepareTime;
  final DateTime collectTime;
  final int personsCount;
  final Map<String, int> drinkQuantities;
}

class FoodSetupReserveInput {
  const FoodSetupReserveInput({
    required this.roomName,
    required this.prepareTime,
    required this.collectTime,
    required this.personsCount,
    required this.itemQuantities,
  });

  final String roomName;
  final DateTime prepareTime;
  final DateTime collectTime;
  final int personsCount;
  final Map<String, int> itemQuantities;
}

class NoteReserveInput {
  const NoteReserveInput({
    required this.roomName,
    required this.prepareTime,
    required this.collectTime,
    required this.title,
    required this.note,
  });

  final String roomName;
  final DateTime prepareTime;
  final DateTime collectTime;
  final String title;
  final String note;
}

class ReserveToTaskMapper {
  ReserveToTaskMapper._();

  static const _waterDrinkIds = {
    'sprudel_07',
    'still_07',
    'sprudel_025',
    'still_025',
    // Backward compatibility for older data IDs.
    'water',
  };

  static const _coffeeIds = {
    'kaffee',
    // Backward compatibility for older data IDs.
    'coffee',
  };

  static const _teaIds = {
    'tee',
    // Backward compatibility for older data IDs.
    'tea',
  };

  static final Map<String, String> _drinkNameById = {
    for (final drink in AppConstants.drinkDefinitions) drink.id: drink.name,
  };

  static final Map<String, String> _setupNameById = {
    for (final item in AppConstants.foodSetupDefinitions) item.id: item.name,
  };

  static TaskItem mapDrinks(DrinksReserveInput input) {
    final orderedDrinks = input.drinkQuantities.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) => DrinkOrderItem(
            id: entry.key,
            name: _drinkNameById[entry.key] ?? entry.key,
            quantity: entry.value,
          ),
        )
        .toList();

    final derived = _buildDerivedItems(
      personsCount: input.personsCount,
      drinkQuantities: input.drinkQuantities,
    );

    final leadingItems = orderedDrinks
        .take(2)
        .map((item) => '${item.quantity} ${item.name}')
        .join(' · ');
    final remainingCount = orderedDrinks.length - 2;
    final summaryParts = <String>[
      'Drinks',
      if (leadingItems.isNotEmpty) leadingItems,
      if (remainingCount > 0) '+$remainingCount items',
      '${input.personsCount} persons',
    ];

    return TaskItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      roomName: input.roomName,
      prepareTime: input.prepareTime,
      collectTime: input.collectTime,
      category: TaskCategory.drinks,
      personsCount: input.personsCount,
      orderedDrinks: orderedDrinks,
      derivedItems: derived,
      shortDescription: summaryParts.join(' · '),
      note: null,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
    );
  }

  static TaskItem mapFoodSetup(FoodSetupReserveInput input) {
    final setupItems = input.itemQuantities.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) => DrinkOrderItem(
            id: entry.key,
            name: _setupNameById[entry.key] ?? entry.key,
            quantity: entry.value,
          ),
        )
        .toList();

    final leadingItems = setupItems
        .take(2)
        .map((item) => '${item.quantity} ${item.name}')
        .join(' · ');
    final remainingCount = setupItems.length - 2;

    final summary = [
      'Food setup',
      '${input.personsCount} persons',
      if (leadingItems.isNotEmpty) leadingItems,
      if (remainingCount > 0) '+$remainingCount items',
    ].join(' · ');

    return TaskItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      roomName: input.roomName,
      prepareTime: input.prepareTime,
      collectTime: input.collectTime,
      category: TaskCategory.foodSetup,
      personsCount: input.personsCount,
      orderedDrinks: setupItems,
      derivedItems: const [],
      shortDescription: summary,
      note: null,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
    );
  }

  static TaskItem mapNote(NoteReserveInput input) {
    final trimmedTitle = input.title.trim();
    final trimmedNote = input.note.trim();

    return TaskItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      roomName: input.roomName,
      prepareTime: input.prepareTime,
      collectTime: input.collectTime,
      category: TaskCategory.note,
      personsCount: null,
      orderedDrinks: const [],
      derivedItems: const [],
      shortDescription: trimmedTitle.isNotEmpty ? trimmedTitle : 'Note request',
      note: trimmedNote,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
    );
  }

  static List<DerivedItem> _buildDerivedItems({
    required int personsCount,
    required Map<String, int> drinkQuantities,
  }) {
    final merged = <String, int>{};

    void mergeMax(String id, int quantity) {
      final existing = merged[id] ?? 0;
      merged[id] = quantity > existing ? quantity : existing;
    }

    final hasCoffee = drinkQuantities.entries.any(
      (entry) => _coffeeIds.contains(entry.key) && entry.value > 0,
    );
    if (hasCoffee) {
      mergeMax('cups', personsCount);
      mergeMax('napkins', personsCount);
    }

    final hasTea = drinkQuantities.entries.any(
      (entry) => _teaIds.contains(entry.key) && entry.value > 0,
    );
    if (hasTea) {
      mergeMax('cups', personsCount);
      mergeMax('napkins', personsCount);
    }

    final hasWater = drinkQuantities.entries.any(
      (entry) => _waterDrinkIds.contains(entry.key) && entry.value > 0,
    );
    if (hasWater) {
      mergeMax('glasses', personsCount);
    }

    const itemNames = {
      'cups': 'Cups',
      'napkins': 'Napkins',
      'glasses': 'Glasses',
    };

    final items = merged.entries
        .map(
          (entry) => DerivedItem(
            id: entry.key,
            name: itemNames[entry.key] ?? entry.key,
            quantity: entry.value,
          ),
        )
        .toList();

    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }
}
