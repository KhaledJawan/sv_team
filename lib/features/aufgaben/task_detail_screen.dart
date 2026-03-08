import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/extensions/date_time_extension.dart';
import '../../core/localization/app_localizations_x.dart';
import '../../core/localization/localized_catalog_names.dart';
import '../../l10n/app_localizations.dart';
import '../../models/derived_item.dart';
import '../../models/drink_order_item.dart';
import '../../models/task_category.dart';
import '../../models/task_item.dart';
import '../../models/task_status.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/quantity_stepper.dart';
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
    final l10n = context.l10n;
    final tasks = ref.watch(tasksProvider);
    final index = tasks.indexWhere((item) => item.id == widget.task.id);

    if (index == -1) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.taskDetailTitle)),
        body: Center(child: Text(l10n.taskNotFound)),
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
                  tooltip: l10n.commonCancel,
                  onPressed: _cancelEditing,
                  icon: const Icon(Icons.close),
                ),
                IconButton(
                  tooltip: l10n.commonSave,
                  onPressed: () => _saveEdits(currentTask),
                  icon: const Icon(Icons.check),
                ),
              ]
            : [
                PopupMenuButton<_TaskDetailAction>(
                  tooltip: l10n.taskActionsTooltip,
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
                      final deleted = ref
                          .read(tasksProvider.notifier)
                          .deleteTask(currentTask.id);
                      if (deleted) {
                        Navigator.of(context).maybePop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.aufgabenDailySnackNoDelete),
                          ),
                        );
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _TaskDetailAction.edit,
                      child: Text(l10n.commonEdit),
                    ),
                    PopupMenuItem(
                      value: _TaskDetailAction.delete,
                      child: Text(l10n.commonDelete),
                    ),
                  ],
                ),
              ],
      ),
      body: _isEditing ? _buildEditBody() : _buildReadOnlyBody(currentTask),
    );
  }

  Widget _buildReadOnlyBody(TaskItem currentTask) {
    final l10n = context.l10n;
    final hasCollectTime = currentTask.category != TaskCategory.snacky;
    final collectIsBold = currentTask.status == TaskStatus.prepared;
    final itemSectionTitle = switch (currentTask.category) {
      TaskCategory.drinks => l10n.taskItemsOrderedDrinks,
      TaskCategory.foodSetup => l10n.taskItemsSetup,
      TaskCategory.note => l10n.taskItemsGeneric,
      TaskCategory.snacky => l10n.taskItemsGeneric,
      TaskCategory.others => l10n.taskItemsGeneric,
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
                _SectionTitle(l10n.taskStatusSection),
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
                _SectionTitle(l10n.taskSummarySection),
                const SizedBox(height: 8),
                Text(
                  _localizedSummaryText(l10n: l10n, task: currentTask),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(l10n.taskInfoSection),
                const SizedBox(height: 8),
                _InfoRow(
                  label: l10n.taskRoomLabel,
                  value: currentTask.roomName,
                ),
                _InfoRow(
                  label: l10n.taskPrepareTimeLabel,
                  value: currentTask.prepareTime.ddMmYyyyOrTodayHhMmLabel(
                    l10n.commonToday,
                  ),
                ),
                if (hasCollectTime)
                  _InfoRow(
                    label: l10n.taskCollectTimeLabel,
                    value: currentTask.collectTime.ddMmYyyyOrTodayHhMmLabel(
                      l10n.commonToday,
                    ),
                    valueStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: collectIsBold
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                _InfoRow(
                  label: l10n.commonCategory,
                  value: currentTask.category.localizedLabel(l10n),
                ),
                if (currentTask.personsCount != null)
                  _InfoRow(
                    label: l10n.taskPersonsLabel,
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
                  Text(l10n.taskNoItems)
                else
                  ...currentTask.orderedDrinks.map(
                    (item) => _InfoRow(
                      label: _localizedItemName(
                        l10n: l10n,
                        category: currentTask.category,
                        item: item,
                      ),
                      value: '${item.quantity}',
                    ),
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
                  _SectionTitle(l10n.taskAutoGeneratedSupportTitle),
                  const SizedBox(height: 8),
                  if (currentTask.derivedItems.isEmpty)
                    Text(l10n.taskNoSupportItems)
                  else
                    ...currentTask.derivedItems.map(
                      (item) => _InfoRow(
                        label: localizedDerivedItemName(
                          l10n,
                          item.id,
                          fallback: item.name,
                        ),
                        value: '${item.quantity}',
                      ),
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
                _SectionTitle(l10n.taskNoteSection),
                const SizedBox(height: 8),
                Text(
                  currentTask.note?.trim().isNotEmpty == true
                      ? currentTask.note!
                      : l10n.taskNoNote,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditBody() {
    final l10n = context.l10n;
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
                _SectionTitle(l10n.taskEditSection),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  key: ValueKey('edit_room_$_roomNameDraft'),
                  initialValue: _roomNameDraft,
                  decoration: InputDecoration(labelText: l10n.commonRoom),
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
                _EditableDateField(
                  labelText: l10n.taskPrepareDateLabel,
                  value: _prepareTimeDraft.ddMmYyyyOrTodayLabel(
                    l10n.commonToday,
                  ),
                  onTap: _pickPrepareDate,
                ),
                const SizedBox(height: 10),
                _EditableTimeField(
                  labelText: l10n.taskPrepareTimeLabel,
                  value: _prepareTimeDraft.hhMm,
                  onTap: _pickPrepareTime,
                ),
                if (_categoryDraft != TaskCategory.snacky) ...[
                  const SizedBox(height: 10),
                  _EditableDateField(
                    labelText: l10n.taskCollectDateLabel,
                    value: _collectTimeDraft.ddMmYyyyOrTodayLabel(
                      l10n.commonToday,
                    ),
                    onTap: _pickCollectDate,
                  ),
                  const SizedBox(height: 10),
                  _EditableTimeField(
                    labelText: l10n.taskCollectTimeLabel,
                    value: _collectTimeDraft.hhMm,
                    onTap: _pickCollectTime,
                  ),
                ],
                const SizedBox(height: 10),
                DropdownButtonFormField<TaskCategory>(
                  key: ValueKey('edit_category_${_categoryDraft.name}'),
                  initialValue: _categoryDraft,
                  decoration: InputDecoration(labelText: l10n.commonCategory),
                  items: TaskCategory.values
                      .map(
                        (category) => DropdownMenuItem<TaskCategory>(
                          value: category,
                          child: Text(category.localizedLabel(l10n)),
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
                    decoration: InputDecoration(
                      labelText: l10n.taskNumberOfPeopleLabel,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                TextFormField(
                  controller: _shortDescriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.taskShortDescriptionLabel,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _noteController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: l10n.commonNote,
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
                _SectionTitle(l10n.taskStatusSection),
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
                        ? l10n.taskDrinksItemsLabel
                        : l10n.taskFoodSetupItemsLabel,
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

  Future<void> _pickPrepareDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _prepareTimeDraft,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (selected == null) {
      return;
    }

    setState(() {
      _prepareTimeDraft = DateTime(
        selected.year,
        selected.month,
        selected.day,
        _prepareTimeDraft.hour,
        _prepareTimeDraft.minute,
      );
      if (_categoryDraft == TaskCategory.snacky) {
        _collectTimeDraft = _prepareTimeDraft;
      }
    });
  }

  Future<void> _pickCollectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _collectTimeDraft,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (selected == null) {
      return;
    }

    setState(() {
      _collectTimeDraft = DateTime(
        selected.year,
        selected.month,
        selected.day,
        _collectTimeDraft.hour,
        _collectTimeDraft.minute,
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
    final l10n = context.l10n;
    final roomName = _roomNameDraft.trim();
    if (roomName.isEmpty) {
      _showError(l10n.taskErrorRoomRequired);
      return;
    }
    if (_categoryDraft != TaskCategory.snacky &&
        !_collectTimeDraft.isAfter(_prepareTimeDraft)) {
      _showError(l10n.validationCollectAfterPrepare);
      return;
    }

    int? personsCount;
    if (_categoryDraft != TaskCategory.note) {
      final parsed = int.tryParse(_personsController.text.trim());
      if (parsed == null || parsed < 1) {
        _showError(l10n.validationPersonsInvalid);
        return;
      }
      personsCount = parsed;
    }

    final orderedItems = _buildOrderedItems(_categoryDraft);
    if ((_categoryDraft == TaskCategory.drinks ||
            _categoryDraft == TaskCategory.foodSetup) &&
        orderedItems.isEmpty) {
      _showError(l10n.taskErrorAddItem);
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

    final collectTime = _categoryDraft == TaskCategory.snacky
        ? _prepareTimeDraft
        : _collectTimeDraft;

    final updatedTask = currentTask.copyWith(
      roomName: roomName,
      prepareTime: _prepareTimeDraft,
      collectTime: collectTime,
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
    ).showSnackBar(SnackBar(content: Text(l10n.taskUpdated)));
  }

  Future<void> _confirmStatusChange({
    required TaskItem task,
    required TaskStatus nextStatus,
  }) async {
    final l10n = context.l10n;
    if (task.status == nextStatus) {
      return;
    }

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.taskSaveStatusChangeTitle),
          content: Text(
            l10n.taskChangeStatusMessage(
              task.status.localizedLabel(l10n),
              nextStatus.localizedLabel(l10n),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.commonSaveClose),
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
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.aufgabenDeleteTaskTitle),
          content: Text(l10n.aufgabenDeleteTaskBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.commonDelete),
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

    const coffeeIds = {'kaffee', 'coffee'};
    final hasCoffee = quantities.entries.any(
      (entry) => coffeeIds.contains(entry.key) && entry.value > 0,
    );
    if (hasCoffee) {
      mergeMax('cups', personsCount);
      mergeMax('napkins', personsCount);
    }

    const teaIds = {'tee', 'tea'};
    final hasTea = quantities.entries.any(
      (entry) => teaIds.contains(entry.key) && entry.value > 0,
    );
    if (hasTea) {
      mergeMax('cups', personsCount);
      mergeMax('napkins', personsCount);
    }

    const waterIds = {
      'sprudel_07',
      'still_07',
      'sprudel_025',
      'still_025',
      'water',
    };
    final hasWater = quantities.entries.any(
      (entry) => waterIds.contains(entry.key) && entry.value > 0,
    );
    if (hasWater) {
      mergeMax('glasses', personsCount);
    }

    const names = {'cups': 'Cups', 'napkins': 'Napkins', 'glasses': 'Glasses'};

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
    final l10n = context.l10n;
    if (category == TaskCategory.note) {
      return l10n.taskDescriptionNoteRequest;
    }

    if (orderedItems.isEmpty) {
      return category.localizedLabel(l10n);
    }

    final parts = <String>[];
    if (category == TaskCategory.drinks || category == TaskCategory.foodSetup) {
      parts.add(
        category == TaskCategory.drinks
            ? l10n.taskDescriptionDrinks
            : l10n.taskDescriptionFoodSetup,
      );
      final leadingItems = orderedItems
          .take(2)
          .map((item) => '${item.quantity} ${item.name}')
          .join(' · ');
      if (leadingItems.isNotEmpty) {
        parts.add(leadingItems);
      }
      final remainingCount = orderedItems.length - 2;
      if (remainingCount > 0) {
        parts.add(l10n.taskMoreItems(remainingCount));
      }
    } else {
      parts.addAll(orderedItems.map((item) => '${item.quantity} ${item.name}'));
    }

    if (personsCount != null) {
      parts.add(l10n.taskPersons(personsCount));
    }
    return parts.join(' · ');
  }

  List<_EditableItemDefinition> _itemDefinitionsForCategory(
    TaskCategory category,
  ) {
    switch (category) {
      case TaskCategory.drinks:
        return AppConstants.drinkDefinitions
            .map(
              (drink) => _EditableItemDefinition(
                drink.id,
                localizedDrinkName(
                  context.l10n,
                  drink.id,
                  fallback: drink.name,
                ),
              ),
            )
            .toList();
      case TaskCategory.foodSetup:
        return AppConstants.foodSetupDefinitions
            .map(
              (item) => _EditableItemDefinition(
                item.id,
                localizedFoodSetupName(
                  context.l10n,
                  item.id,
                  fallback: item.name,
                ),
              ),
            )
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

  String _localizedItemName({
    required AppLocalizations l10n,
    required TaskCategory category,
    required DrinkOrderItem item,
  }) {
    switch (category) {
      case TaskCategory.drinks:
        return localizedDrinkName(l10n, item.id, fallback: item.name);
      case TaskCategory.foodSetup:
        return localizedFoodSetupName(l10n, item.id, fallback: item.name);
      case TaskCategory.note:
      case TaskCategory.snacky:
      case TaskCategory.others:
        return item.name;
    }
  }

  String _localizedSummaryText({
    required AppLocalizations l10n,
    required TaskItem task,
  }) {
    if (task.category != TaskCategory.drinks &&
        task.category != TaskCategory.foodSetup) {
      return task.shortDescription;
    }

    if (task.orderedDrinks.isEmpty) {
      return task.shortDescription;
    }

    final localizedItems = task.orderedDrinks
        .map(
          (item) => item.copyWith(
            name: _localizedItemName(
              l10n: l10n,
              category: task.category,
              item: item,
            ),
          ),
        )
        .toList();

    final leadingItems = localizedItems
        .take(2)
        .map((item) => '${item.quantity} ${item.name}')
        .join(' · ');
    final remainingCount = localizedItems.length - 2;
    final parts = <String>[
      task.category == TaskCategory.drinks
          ? l10n.taskDescriptionDrinks
          : l10n.taskDescriptionFoodSetup,
      if (leadingItems.isNotEmpty) leadingItems,
      if (remainingCount > 0) l10n.taskMoreItems(remainingCount),
      if (task.personsCount != null) l10n.taskPersons(task.personsCount!),
    ];
    return parts.join(' · ');
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

class _EditableDateField extends StatelessWidget {
  const _EditableDateField({
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
          suffixIcon: const Icon(Icons.calendar_today_outlined),
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
  const _InfoRow({required this.label, required this.value, this.valueStyle});

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            value,
            style: valueStyle ?? Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
