import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/extensions/date_time_extension.dart';
import '../../core/localization/app_localizations_x.dart';
import '../../core/localization/localized_catalog_names.dart';
import '../../l10n/app_localizations.dart';
import '../../models/drink_order_item.dart';
import '../../models/room.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/quantity_stepper.dart';
import '../aufgaben/providers/tasks_provider.dart';
import 'providers/food_setup_form_provider.dart';
import 'providers/note_form_provider.dart';
import 'providers/reserve_form_provider.dart';
import 'providers/reserve_type_provider.dart';
import 'providers/rooms_provider.dart';
import 'services/reserve_to_task_mapper.dart';
import 'widgets/reserve_section_header.dart';

class ReserveScreen extends ConsumerWidget {
  const ReserveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedType = ref.watch(reserveRequestTypeProvider);
    final rooms = ref.watch(roomsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReserveSectionHeader(title: l10n.reserveTitle),
          const SizedBox(height: 4),
          Text(l10n.reserveIntro, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          AppCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ReserveRequestType.values
                  .map(
                    (type) => ChoiceChip(
                      label: Text(type.localizedLabel(l10n)),
                      selected: selectedType == type,
                      onSelected: (_) {
                        ref
                            .read(reserveRequestTypeProvider.notifier)
                            .setType(type);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          if (selectedType == null)
            AppCard(child: Text(l10n.reserveSelectTypeHint))
          else
            switch (selectedType) {
              ReserveRequestType.drinks => const _DrinksReserveForm(),
              ReserveRequestType.foodSetup => const _FoodSetupReserveForm(),
              ReserveRequestType.note => _NoteReserveForm(rooms: rooms),
            },
        ],
      ),
    );
  }
}

class _DrinksReserveForm extends ConsumerWidget {
  const _DrinksReserveForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final formState = ref.watch(reserveFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReserveSectionHeader(title: l10n.reserveDrinksRequestTitle),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: formState.roomNameInput,
                decoration: InputDecoration(labelText: l10n.commonRoom),
                onChanged: (value) {
                  ref.read(reserveFormProvider.notifier).setRoomName(value);
                },
              ),
              const SizedBox(height: 10),
              _DateField(
                labelText: l10n.reserveReservationDate,
                selectedDate: formState.selectedDate,
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: formState.selectedDate,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                  );
                  if (selected != null) {
                    ref.read(reserveFormProvider.notifier).setDate(selected);
                  }
                },
              ),
              const SizedBox(height: 10),
              _TimeField(
                labelText: l10n.reservePrepareTime,
                selectedTime: formState.selectedPrepareTime,
                onTap: () async {
                  final selected = await showTimePicker(
                    context: context,
                    initialTime:
                        formState.selectedPrepareTime ?? TimeOfDay.now(),
                  );
                  if (selected != null) {
                    ref
                        .read(reserveFormProvider.notifier)
                        .setPrepareTime(selected);
                  }
                },
              ),
              const SizedBox(height: 10),
              _TimeField(
                labelText: l10n.reserveCollectTime,
                selectedTime: formState.selectedCollectTime,
                onTap: () async {
                  final selected = await showTimePicker(
                    context: context,
                    initialTime:
                        formState.selectedCollectTime ??
                        formState.selectedPrepareTime ??
                        TimeOfDay.now(),
                  );
                  if (selected != null) {
                    ref
                        .read(reserveFormProvider.notifier)
                        .setCollectTime(selected);
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: formState.personsInput,
                decoration: InputDecoration(labelText: l10n.reservePeopleCount),
                onChanged: (value) {
                  ref.read(reserveFormProvider.notifier).setPersonsInput(value);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReserveSectionHeader(title: l10n.reserveDrinksSectionTitle),
              const SizedBox(height: 6),
              ...AppConstants.drinkDefinitions.map((drink) {
                final quantity = formState.drinkQuantities[drink.id] ?? 0;
                final localizedName = localizedDrinkName(
                  l10n,
                  drink.id,
                  fallback: drink.name,
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          localizedName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      QuantityStepper(
                        value: quantity,
                        onIncrement: () {
                          ref
                              .read(reserveFormProvider.notifier)
                              .incrementDrink(drink.id);
                        },
                        onDecrement: () {
                          ref
                              .read(reserveFormProvider.notifier)
                              .decrementDrink(drink.id);
                        },
                        onChanged: (value) {
                          ref
                              .read(reserveFormProvider.notifier)
                              .setDrinkQuantity(drink.id, value);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppButton(
          label: l10n.reserveCreateDrinksTask,
          onPressed: () => _submit(context: context, ref: ref),
        ),
      ],
    );
  }

  void _submit({required BuildContext context, required WidgetRef ref}) {
    final l10n = context.l10n;
    final formState = ref.read(reserveFormProvider);

    final roomName = formState.roomNameInput.trim();
    if (roomName.isEmpty) {
      _showError(context, l10n.validationSelectRoom);
      return;
    }
    if (formState.selectedPrepareTime == null) {
      _showError(context, l10n.validationSelectPrepareTime);
      return;
    }
    if (formState.selectedCollectTime == null) {
      _showError(context, l10n.validationSelectCollectTime);
      return;
    }
    final personsCount = formState.parsedPersonsCount;
    if (personsCount == null) {
      _showError(context, l10n.validationPersonsInvalid);
      return;
    }
    if (!formState.hasAnyDrink) {
      _showError(context, l10n.validationAddDrink);
      return;
    }

    final prepareTime = _composeReservationDateTime(
      formState.selectedPrepareTime!,
      selectedDate: formState.selectedDate,
    );
    final collectTime = _composeReservationDateTime(
      formState.selectedCollectTime!,
      baseDate: prepareTime,
    );
    if (!collectTime.isAfter(prepareTime)) {
      _showError(context, l10n.validationCollectAfterPrepare);
      return;
    }

    final task = ReserveToTaskMapper.mapDrinks(
      DrinksReserveInput(
        roomName: roomName,
        prepareTime: prepareTime,
        collectTime: collectTime,
        personsCount: personsCount,
        drinkQuantities: formState.drinkQuantities,
      ),
    );
    final localizedOrderedItems = task.orderedDrinks
        .map(
          (item) => item.copyWith(
            name: localizedDrinkName(l10n, item.id, fallback: item.name),
          ),
        )
        .toList();
    final localizedDerivedItems = task.derivedItems
        .map(
          (item) => item.copyWith(
            name: localizedDerivedItemName(l10n, item.id, fallback: item.name),
          ),
        )
        .toList();
    final localizedTask = task.copyWith(
      orderedDrinks: localizedOrderedItems,
      derivedItems: localizedDerivedItems,
      shortDescription: _buildDrinksSummary(
        l10n: l10n,
        orderedItems: localizedOrderedItems,
        personsCount: personsCount,
      ),
    );

    ref.read(tasksProvider.notifier).addTask(localizedTask);
    ref.read(reserveFormProvider.notifier).reset();
    ref.read(reserveRequestTypeProvider.notifier).clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.reserveSuccessDrinksAdded)));
  }
}

class _FoodSetupReserveForm extends ConsumerWidget {
  const _FoodSetupReserveForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final formState = ref.watch(foodSetupFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReserveSectionHeader(title: l10n.reserveFoodSetupRequestTitle),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: formState.roomNameInput,
                decoration: InputDecoration(labelText: l10n.commonRoom),
                onChanged: (value) {
                  ref.read(foodSetupFormProvider.notifier).setRoomName(value);
                },
              ),
              const SizedBox(height: 10),
              _DateField(
                labelText: l10n.reserveReservationDate,
                selectedDate: formState.selectedDate,
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: formState.selectedDate,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                  );
                  if (selected != null) {
                    ref.read(foodSetupFormProvider.notifier).setDate(selected);
                  }
                },
              ),
              const SizedBox(height: 10),
              _TimeField(
                labelText: l10n.reservePrepareTime,
                selectedTime: formState.selectedPrepareTime,
                onTap: () async {
                  final selected = await showTimePicker(
                    context: context,
                    initialTime:
                        formState.selectedPrepareTime ?? TimeOfDay.now(),
                  );
                  if (selected != null) {
                    ref
                        .read(foodSetupFormProvider.notifier)
                        .setPrepareTime(selected);
                  }
                },
              ),
              const SizedBox(height: 10),
              _TimeField(
                labelText: l10n.reserveCollectTime,
                selectedTime: formState.selectedCollectTime,
                onTap: () async {
                  final selected = await showTimePicker(
                    context: context,
                    initialTime:
                        formState.selectedCollectTime ??
                        formState.selectedPrepareTime ??
                        TimeOfDay.now(),
                  );
                  if (selected != null) {
                    ref
                        .read(foodSetupFormProvider.notifier)
                        .setCollectTime(selected);
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: formState.personsInput,
                decoration: InputDecoration(labelText: l10n.reservePeopleCount),
                onChanged: (value) {
                  ref
                      .read(foodSetupFormProvider.notifier)
                      .setPersonsInput(value);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReserveSectionHeader(title: l10n.reserveFoodSetupItemsTitle),
              const SizedBox(height: 6),
              ...AppConstants.foodSetupDefinitions.map((item) {
                final quantity = formState.itemQuantities[item.id] ?? 0;
                final localizedName = localizedFoodSetupName(
                  l10n,
                  item.id,
                  fallback: item.name,
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          localizedName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      QuantityStepper(
                        value: quantity,
                        onIncrement: () {
                          ref
                              .read(foodSetupFormProvider.notifier)
                              .incrementItem(item.id);
                        },
                        onDecrement: () {
                          ref
                              .read(foodSetupFormProvider.notifier)
                              .decrementItem(item.id);
                        },
                        onChanged: (value) {
                          ref
                              .read(foodSetupFormProvider.notifier)
                              .setItemQuantity(item.id, value);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppButton(
          label: l10n.reserveCreateFoodSetupTask,
          onPressed: () => _submit(context: context, ref: ref),
        ),
      ],
    );
  }

  void _submit({required BuildContext context, required WidgetRef ref}) {
    final l10n = context.l10n;
    final formState = ref.read(foodSetupFormProvider);

    final roomName = formState.roomNameInput.trim();
    if (roomName.isEmpty) {
      _showError(context, l10n.validationSelectRoom);
      return;
    }
    if (formState.selectedPrepareTime == null) {
      _showError(context, l10n.validationSelectPrepareTime);
      return;
    }
    if (formState.selectedCollectTime == null) {
      _showError(context, l10n.validationSelectCollectTime);
      return;
    }
    final personsCount = formState.parsedPersonsCount;
    if (personsCount == null) {
      _showError(context, l10n.validationPersonsInvalid);
      return;
    }
    if (!formState.hasAnyItem) {
      _showError(context, l10n.validationAddSetupItem);
      return;
    }

    final prepareTime = _composeReservationDateTime(
      formState.selectedPrepareTime!,
      selectedDate: formState.selectedDate,
    );
    final collectTime = _composeReservationDateTime(
      formState.selectedCollectTime!,
      baseDate: prepareTime,
    );
    if (!collectTime.isAfter(prepareTime)) {
      _showError(context, l10n.validationCollectAfterPrepare);
      return;
    }

    final task = ReserveToTaskMapper.mapFoodSetup(
      FoodSetupReserveInput(
        roomName: roomName,
        prepareTime: prepareTime,
        collectTime: collectTime,
        personsCount: personsCount,
        itemQuantities: formState.itemQuantities,
      ),
    );
    final localizedOrderedItems = task.orderedDrinks
        .map(
          (item) => item.copyWith(
            name: localizedFoodSetupName(l10n, item.id, fallback: item.name),
          ),
        )
        .toList();
    final localizedTask = task.copyWith(
      orderedDrinks: localizedOrderedItems,
      shortDescription: _buildFoodSetupSummary(
        l10n: l10n,
        orderedItems: localizedOrderedItems,
        personsCount: personsCount,
      ),
    );

    ref.read(tasksProvider.notifier).addTask(localizedTask);
    ref.read(foodSetupFormProvider.notifier).reset();
    ref.read(reserveRequestTypeProvider.notifier).clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.reserveSuccessFoodAdded)));
  }
}

class _NoteReserveForm extends ConsumerWidget {
  const _NoteReserveForm({required this.rooms});

  final List<Room> rooms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final formState = ref.watch(noteFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReserveSectionHeader(title: l10n.reserveNoteRequestTitle),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                key: ValueKey(
                  'note_room_${formState.selectedRoomId ?? 'none'}',
                ),
                initialValue: formState.selectedRoomId,
                decoration: InputDecoration(labelText: l10n.commonSelectRoom),
                items: rooms
                    .map(
                      (room) => DropdownMenuItem<String>(
                        value: room.id,
                        child: Text(room.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  ref.read(noteFormProvider.notifier).setRoom(value);
                },
              ),
              const SizedBox(height: 10),
              _TimeField(
                labelText: l10n.reservePrepareTime,
                selectedTime: formState.selectedPrepareTime,
                onTap: () async {
                  final selected = await showTimePicker(
                    context: context,
                    initialTime:
                        formState.selectedPrepareTime ?? TimeOfDay.now(),
                  );
                  if (selected != null) {
                    ref
                        .read(noteFormProvider.notifier)
                        .setPrepareTime(selected);
                  }
                },
              ),
              const SizedBox(height: 10),
              _TimeField(
                labelText: l10n.reserveCollectTime,
                selectedTime: formState.selectedCollectTime,
                onTap: () async {
                  final selected = await showTimePicker(
                    context: context,
                    initialTime:
                        formState.selectedCollectTime ??
                        formState.selectedPrepareTime ??
                        TimeOfDay.now(),
                  );
                  if (selected != null) {
                    ref
                        .read(noteFormProvider.notifier)
                        .setCollectTime(selected);
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: formState.titleInput,
                decoration: InputDecoration(
                  labelText: l10n.reserveTitleOptional,
                ),
                onChanged: (value) {
                  ref.read(noteFormProvider.notifier).setTitle(value);
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: formState.noteInput,
                minLines: 4,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: l10n.reserveNoteDescription,
                  alignLabelWithHint: true,
                ),
                onChanged: (value) {
                  ref.read(noteFormProvider.notifier).setNote(value);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppButton(
          label: l10n.reserveCreateNoteTask,
          onPressed: () => _submit(context: context, ref: ref),
        ),
      ],
    );
  }

  void _submit({required BuildContext context, required WidgetRef ref}) {
    final l10n = context.l10n;
    final formState = ref.read(noteFormProvider);

    if (formState.selectedRoomId == null) {
      _showError(context, l10n.validationSelectRoom);
      return;
    }
    if (formState.selectedPrepareTime == null) {
      _showError(context, l10n.validationSelectPrepareTime);
      return;
    }
    if (formState.selectedCollectTime == null) {
      _showError(context, l10n.validationSelectCollectTime);
      return;
    }
    if (formState.noteInput.trim().isEmpty) {
      _showError(context, l10n.validationNoteRequired);
      return;
    }

    final selectedRoom = rooms.firstWhere(
      (room) => room.id == formState.selectedRoomId,
    );
    final prepareTime = _composeReservationDateTime(
      formState.selectedPrepareTime!,
    );
    final collectTime = _composeReservationDateTime(
      formState.selectedCollectTime!,
      baseDate: prepareTime,
    );
    if (!collectTime.isAfter(prepareTime)) {
      _showError(context, l10n.validationCollectAfterPrepare);
      return;
    }

    final task = ReserveToTaskMapper.mapNote(
      NoteReserveInput(
        roomName: selectedRoom.name,
        prepareTime: prepareTime,
        collectTime: collectTime,
        title: formState.titleInput,
        note: formState.noteInput,
      ),
    );

    ref.read(tasksProvider.notifier).addTask(task);
    ref.read(noteFormProvider.notifier).reset();
    ref.read(reserveRequestTypeProvider.notifier).clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.reserveSuccessNoteAdded)));
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.labelText,
    required this.selectedTime,
    required this.onTap,
  });

  final String labelText;
  final TimeOfDay? selectedTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = selectedTime == null
        ? l10n.commonSelectTime
        : selectedTime!.format(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: Icon(Icons.schedule_outlined),
        ),
        child: Text(label),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.labelText,
    required this.selectedDate,
    required this.onTap,
  });

  final String labelText;
  final DateTime selectedDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = selectedDate.ddMmYyyyOrTodayLabel(context.l10n.commonToday);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(label),
      ),
    );
  }
}

DateTime _composeReservationDateTime(
  TimeOfDay selectedTime, {
  DateTime? selectedDate,
  DateTime? baseDate,
}) {
  final dateBase = selectedDate ?? baseDate ?? DateTime.now();
  final now = DateTime.now();
  var scheduled = DateTime(
    dateBase.year,
    dateBase.month,
    dateBase.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  if (selectedDate == null && baseDate == null && scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}

String _buildDrinksSummary({
  required AppLocalizations l10n,
  required List<DrinkOrderItem> orderedItems,
  required int personsCount,
}) {
  final leadingItems = orderedItems
      .take(2)
      .map((item) => '${item.quantity} ${item.name}')
      .join(' · ');
  final remainingCount = orderedItems.length - 2;

  final parts = <String>[
    l10n.taskDescriptionDrinks,
    if (leadingItems.isNotEmpty) leadingItems,
    if (remainingCount > 0) l10n.taskMoreItems(remainingCount),
    l10n.taskPersons(personsCount),
  ];

  return parts.join(' · ');
}

String _buildFoodSetupSummary({
  required AppLocalizations l10n,
  required List<DrinkOrderItem> orderedItems,
  required int personsCount,
}) {
  final leadingItems = orderedItems
      .take(2)
      .map((item) => '${item.quantity} ${item.name}')
      .join(' · ');
  final remainingCount = orderedItems.length - 2;

  final parts = <String>[
    l10n.taskDescriptionFoodSetup,
    l10n.taskPersons(personsCount),
    if (leadingItems.isNotEmpty) leadingItems,
    if (remainingCount > 0) l10n.taskMoreItems(remainingCount),
  ];

  return parts.join(' · ');
}

void _showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
