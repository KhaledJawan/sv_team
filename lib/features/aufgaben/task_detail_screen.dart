import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/extensions/date_time_extension.dart';
import '../../models/derived_item.dart';
import '../../models/drink_order_item.dart';
import '../../models/task_category.dart';
import '../../models/task_item.dart';
import '../../models/task_status.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/quantity_stepper.dart';
import '../../shared/widgets/status_indicator.dart';
import 'providers/tasks_provider.dart';
import 'widgets/task_status_selector.dart';

enum _TaskDetailAction { edit, delete }

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key, required this.task});

  final TaskItem task;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  bool _isEditing = false;

  late String _roomNameDraft;
  late DateTime _prepareTimeDraft;
  late DateTime _collectTimeDraft;
  late TaskCategory _categoryDraft;
  late TaskStatus _statusDraft;
  late Map<String, int> _itemQuantities;

  late final TextEditingController _personsController;
  late final TextEditingController _shortDescriptionController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _personsController = TextEditingController();
    _shortDescriptionController = TextEditingController();
    _noteController = TextEditingController();
    _syncDraftFromTask(widget.task);
  }

  @override
  void dispose() {
    _personsController.dispose();
    _shortDescriptionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    final index = tasks.indexWhere((item) => item.id == widget.task.id);

    if (index == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task')),
        body: const Center(child: Text('Task not found.')),
      );
    }

    final currentTask = tasks[index];
    if (!_isEditing) {
      _syncDraftFromTask(currentTask);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentTask.roomName),
        actions: _isEditing
            ? [
                IconButton(
                  tooltip: 'Cancel',
                  onPressed: _cancelEditing,
                  icon: const Icon(Icons.close),
                ),
                IconButton(
                  tooltip: 'Save',
                  onPressed: () => _saveEdits(currentTask),
                  icon: const Icon(Icons.check),
                ),
              ]
            : [
                PopupMenuButton<_TaskDetailAction>(
                  tooltip: 'Task actions',
                  onSelected: (action) async {
                    if (action == _TaskDetailAction.edit) {
                      _startEditing(currentTask);
                      return;
                    }

                    final shouldDelete = await _showDeleteDialog(context);
                    if (!context.mounted) {
                      return;
                    }
                    if (shouldDelete == true) {
                      ref
                          .read(tasksProvider.notifier)
                          .deleteTask(currentTask.id);
                      Navigator.of(context).maybePop();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: _TaskDetailAction.edit,
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: _TaskDetailAction.delete,
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
      ),
      body: _isEditing ? _buildEditBody() : _buildReadOnlyBody(currentTask),
    );
  }

  Widget _buildReadOnlyBody(TaskItem currentTask) {
    final itemSectionTitle = switch (currentTask.category) {
      TaskCategory.drinks => 'Ordered Drinks',
      TaskCategory.foodSetup => 'Setup Items',
      TaskCategory.note => 'Items',
      TaskCategory.snacky => 'Items',
      TaskCategory.others => 'Items',
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Status'),
                const SizedBox(height: 8),
                TaskStatusSelector(
                  currentStatus: currentTask.status,
                  onChanged: (status) => _confirmStatusChange(
                    task: currentTask,
                    nextStatus: status,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentTask.shortDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      currentTask.category.icon,
                      size: 18,
                      color: const Color(0xFF6E6E73),
                    ),
                    const SizedBox(width: 8),
                    Text(currentTask.category.label),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.schedule,
                      size: 18,
                      color: Color(0xFF6E6E73),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Prep ${currentTask.prepareTime.hhMm} · Collect ${currentTask.collectTime.hhMm}',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                StatusIndicator(status: currentTask.status),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Task Info'),
                const SizedBox(height: 8),
                _InfoRow(label: 'Room', value: currentTask.roomName),
                _InfoRow(
                  label: 'Prepare Time',
                  value: currentTask.prepareTime.hhMm,
                ),
                _InfoRow(
                  label: 'Collect Time',
                  value: currentTask.collectTime.hhMm,
                ),
                _InfoRow(label: 'Category', value: currentTask.category.label),
                if (currentTask.personsCount != null)
                  _InfoRow(
                    label: 'Persons',
                    value: '${currentTask.personsCount}',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(itemSectionTitle),
                const SizedBox(height: 8),
                if (currentTask.orderedDrinks.isEmpty)
                  const Text('No items listed.')
                else
                  ...currentTask.orderedDrinks.map(
                    (item) =>
                        _InfoRow(label: item.name, value: '${item.quantity}'),
                  ),
              ],
            ),
          ),
          if (currentTask.derivedItems.isNotEmpty ||
              currentTask.category == TaskCategory.drinks) ...[
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle('Auto-Generated Support Items'),
                  const SizedBox(height: 8),
                  if (currentTask.derivedItems.isEmpty)
                    const Text('No support items generated.')
                  else
                    ...currentTask.derivedItems.map(
                      (item) =>
                          _InfoRow(label: item.name, value: '${item.quantity}'),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Note'),
                const SizedBox(height: 8),
                Text(
                  currentTask.note?.trim().isNotEmpty == true
                      ? currentTask.note!
                      : 'No note added.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditBody() {
    final itemDefinitions = _itemDefinitionsForCategory(_categoryDraft);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Edit Task'),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  key: ValueKey('edit_room_$_roomNameDraft'),
                  initialValue: _roomNameDraft,
                  decoration: const InputDecoration(labelText: 'Room'),
                  items: AppConstants.roomNames
                      .map(
                        (roomName) => DropdownMenuItem<String>(
                          value: roomName,
                          child: Text(roomName),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _roomNameDraft = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                _EditableTimeField(
                  labelText: 'Prepare Time',
                  value: _prepareTimeDraft.hhMm,
                  onTap: _pickPrepareTime,
                ),
                const SizedBox(height: 10),
                _EditableTimeField(
                  labelText: 'Collect Time',
                  value: _collectTimeDraft.hhMm,
                  onTap: _pickCollectTime,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<TaskCategory>(
                  key: ValueKey('edit_category_${_categoryDraft.name}'),
                  initialValue: _categoryDraft,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: TaskCategory.values
                      .map(
                        (category) => DropdownMenuItem<TaskCategory>(
                          value: category,
                          child: Text(category.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _categoryDraft = value;
                        _ensureItemMapForCategory();
                        if (_categoryDraft == TaskCategory.note) {
                          _personsController.text = '';
                        } else if (_personsController.text.trim().isEmpty) {
                          _personsController.text = '1';
                        }
                      });
                    }
                  },
                ),
                if (_categoryDraft != TaskCategory.note) ...[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _personsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Number of People',
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                TextFormField(
                  controller: _shortDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Short Description',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _noteController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Status'),
                const SizedBox(height: 8),
                TaskStatusSelector(
                  currentStatus: _statusDraft,
                  onChanged: (status) {
                    setState(() {
                      _statusDraft = status;
                    });
                  },
                ),
              ],
            ),
          ),
          if (itemDefinitions.isNotEmpty) ...[
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(
                    _categoryDraft == TaskCategory.drinks
                        ? 'Drinks Items'
                        : 'Food Setup Items',
                  ),
                  const SizedBox(height: 8),
                  ...itemDefinitions.map((item) {
                    final quantity = _itemQuantities[item.id] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(child: Text(item.name)),
                          QuantityStepper(
                            value: quantity,
                            onIncrement: () {
                              setState(() {
                                _itemQuantities[item.id] = quantity + 1;
                              });
                            },
                            onDecrement: () {
                              setState(() {
                                _itemQuantities[item.id] = quantity > 0
                                    ? quantity - 1
                                    : 0;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                _itemQuantities[item.id] = value < 0
                                    ? 0
                                    : value;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickPrepareTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _prepareTimeDraft.hour,
        minute: _prepareTimeDraft.minute,
      ),
    );
    if (selected == null) {
      return;
    }

    setState(() {
      _prepareTimeDraft = DateTime(
        _prepareTimeDraft.year,
        _prepareTimeDraft.month,
        _prepareTimeDraft.day,
        selected.hour,
        selected.minute,
      );
    });
  }

  Future<void> _pickCollectTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _collectTimeDraft.hour,
        minute: _collectTimeDraft.minute,
      ),
    );
    if (selected == null) {
      return;
    }

    setState(() {
      _collectTimeDraft = DateTime(
        _prepareTimeDraft.year,
        _prepareTimeDraft.month,
        _prepareTimeDraft.day,
        selected.hour,
        selected.minute,
      );
    });
  }

  void _startEditing(TaskItem task) {
    setState(() {
      _isEditing = true;
      _syncDraftFromTask(task);
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  void _saveEdits(TaskItem currentTask) {
    final roomName = _roomNameDraft.trim();
    if (roomName.isEmpty) {
      _showError('Room is required.');
      return;
    }
    if (!_collectTimeDraft.isAfter(_prepareTimeDraft)) {
      _showError('Collect time must be after prepare time.');
      return;
    }

    int? personsCount;
    if (_categoryDraft != TaskCategory.note) {
      final parsed = int.tryParse(_personsController.text.trim());
      if (parsed == null || parsed < 1) {
        _showError('Persons count must be a number greater than 0.');
        return;
      }
      personsCount = parsed;
    }

    final orderedItems = _buildOrderedItems(_categoryDraft);
    if ((_categoryDraft == TaskCategory.drinks ||
            _categoryDraft == TaskCategory.foodSetup) &&
        orderedItems.isEmpty) {
      _showError('Add at least one item.');
      return;
    }

    final derivedItems = _categoryDraft == TaskCategory.drinks
        ? _buildDerivedItemsForDrinks(
            personsCount: personsCount ?? 1,
            quantities: _itemQuantities,
          )
        : const <DerivedItem>[];

    final note = _noteController.text.trim();
    var shortDescription = _shortDescriptionController.text.trim();
    if (shortDescription.isEmpty) {
      shortDescription = _buildAutoDescription(
        category: _categoryDraft,
        orderedItems: orderedItems,
        personsCount: personsCount,
      );
    }

    final updatedTask = currentTask.copyWith(
      roomName: roomName,
      prepareTime: _prepareTimeDraft,
      collectTime: _collectTimeDraft,
      category: _categoryDraft,
      personsCount: personsCount,
      orderedDrinks: orderedItems,
      derivedItems: derivedItems,
      shortDescription: shortDescription,
      note: note.isEmpty ? null : note,
      status: _statusDraft,
    );

    ref.read(tasksProvider.notifier).updateTask(updatedTask);

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Task updated.')));
  }

  Future<void> _confirmStatusChange({
    required TaskItem task,
    required TaskStatus nextStatus,
  }) async {
    if (task.status == nextStatus) {
      return;
    }

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Save status change?'),
          content: Text(
            'Change status from ${task.status.label} to ${nextStatus.label}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Save & close'),
            ),
          ],
        );
      },
    );

    if (shouldSave != true) {
      return;
    }

    ref
        .read(tasksProvider.notifier)
        .updateTaskStatus(taskId: task.id, status: nextStatus);

    if (mounted) {
      Navigator.of(context).maybePop();
    }
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete task?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _syncDraftFromTask(TaskItem task) {
    _roomNameDraft = task.roomName;
    _prepareTimeDraft = task.prepareTime;
    _collectTimeDraft = task.collectTime;
    _categoryDraft = task.category;
    _statusDraft = task.status;

    _personsController.text = task.personsCount?.toString() ?? '';
    _shortDescriptionController.text = task.shortDescription;
    _noteController.text = task.note ?? '';

    _itemQuantities = <String, int>{
      for (final item in task.orderedDrinks) item.id: item.quantity,
    };
    _ensureItemMapForCategory();
  }

  void _ensureItemMapForCategory() {
    final defs = _itemDefinitionsForCategory(_categoryDraft);
    if (defs.isEmpty) {
      return;
    }

    _itemQuantities = {
      for (final item in defs) item.id: _itemQuantities[item.id] ?? 0,
    };
  }

  List<DrinkOrderItem> _buildOrderedItems(TaskCategory category) {
    final definitions = _itemDefinitionsForCategory(category);
    if (definitions.isEmpty) {
      return const [];
    }

    final nameById = {for (final def in definitions) def.id: def.name};
    return _itemQuantities.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) => DrinkOrderItem(
            id: entry.key,
            name: nameById[entry.key] ?? entry.key,
            quantity: entry.value,
          ),
        )
        .toList();
  }

  List<DerivedItem> _buildDerivedItemsForDrinks({
    required int personsCount,
    required Map<String, int> quantities,
  }) {
    final merged = <String, int>{};

    void mergeMax(String id, int quantity) {
      final existing = merged[id] ?? 0;
      merged[id] = quantity > existing ? quantity : existing;
    }

    if ((quantities['coffee'] ?? 0) > 0) {
      mergeMax('cups', personsCount);
      mergeMax('saucers', personsCount);
      mergeMax('napkins', personsCount);
    }

    if ((quantities['tea'] ?? 0) > 0) {
      mergeMax('cups', personsCount);
      mergeMax('napkins', personsCount);
    }

    const softDrinkIds = {'juice', 'coca_cola', 'fanta', 'water'};
    final hasSoftDrinks = quantities.entries.any(
      (entry) => softDrinkIds.contains(entry.key) && entry.value > 0,
    );
    if (hasSoftDrinks) {
      mergeMax('glasses', personsCount);
    }

    const names = {
      'cups': 'Cups',
      'saucers': 'Saucers',
      'napkins': 'Napkins',
      'glasses': 'Glasses',
    };

    final items = merged.entries
        .map(
          (entry) => DerivedItem(
            id: entry.key,
            name: names[entry.key] ?? entry.key,
            quantity: entry.value,
          ),
        )
        .toList();

    items.sort((a, b) => a.name.compareTo(b.name));
    return items;
  }

  String _buildAutoDescription({
    required TaskCategory category,
    required List<DrinkOrderItem> orderedItems,
    required int? personsCount,
  }) {
    if (category == TaskCategory.note) {
      return 'Note request';
    }

    if (orderedItems.isEmpty) {
      return category.label;
    }

    final parts = orderedItems
        .map((item) => '${item.quantity} ${item.name}')
        .toList();
    if (personsCount != null) {
      parts.add('$personsCount persons');
    }
    return parts.join(' · ');
  }

  List<_EditableItemDefinition> _itemDefinitionsForCategory(
    TaskCategory category,
  ) {
    switch (category) {
      case TaskCategory.drinks:
        return AppConstants.drinkDefinitions
            .map((drink) => _EditableItemDefinition(drink.id, drink.name))
            .toList();
      case TaskCategory.foodSetup:
        return AppConstants.foodSetupDefinitions
            .map((item) => _EditableItemDefinition(item.id, item.name))
            .toList();
      case TaskCategory.note:
      case TaskCategory.snacky:
      case TaskCategory.others:
        return const [];
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _EditableItemDefinition {
  const _EditableItemDefinition(this.id, this.name);

  final String id;
  final String name;
}

class _EditableTimeField extends StatelessWidget {
  const _EditableTimeField({
    required this.labelText,
    required this.value,
    required this.onTap,
  });

  final String labelText;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: const Icon(Icons.schedule_outlined),
        ),
        child: Text(value),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(value, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
