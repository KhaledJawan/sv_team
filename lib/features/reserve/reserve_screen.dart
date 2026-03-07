import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
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
    final selectedType = ref.watch(reserveRequestTypeProvider);
    final rooms = ref.watch(roomsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ReserveSectionHeader(title: 'Reserve'),
          const SizedBox(height: 4),
          Text(
            'Choose request type first, then complete the form.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ReserveRequestType.values
                  .map(
                    (type) => ChoiceChip(
                      label: Text(type.label),
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
            const AppCard(
              child: Text('Select Drinks, Food Setup, or Note to continue.'),
            )
          else
            switch (selectedType) {
              ReserveRequestType.drinks => _DrinksReserveForm(rooms: rooms),
              ReserveRequestType.foodSetup => _FoodSetupReserveForm(
                rooms: rooms,
              ),
              ReserveRequestType.note => _NoteReserveForm(rooms: rooms),
            },
        ],
      ),
    );
  }
}

class _DrinksReserveForm extends ConsumerWidget {
  const _DrinksReserveForm({required this.rooms});

  final List<Room> rooms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(reserveFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ReserveSectionHeader(title: 'Drinks Request'),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                key: ValueKey(
                  'drinks_room_${formState.selectedRoomId ?? 'none'}',
                ),
                initialValue: formState.selectedRoomId,
                decoration: const InputDecoration(labelText: 'Select Room'),
                items: rooms
                    .map(
                      (room) => DropdownMenuItem<String>(
                        value: room.id,
                        child: Text(room.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  ref.read(reserveFormProvider.notifier).setRoom(value);
                },
              ),
              const SizedBox(height: 10),
              _TimeField(
                labelText: 'Prepare Time',
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
                labelText: 'Collect Time',
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
                decoration: const InputDecoration(
                  labelText: 'Number of People',
                ),
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
              const ReserveSectionHeader(title: 'Drinks'),
              const SizedBox(height: 6),
              ...AppConstants.drinkDefinitions.map((drink) {
                final quantity = formState.drinkQuantities[drink.id] ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          drink.name,
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
          label: 'Create Drinks Aufgabe',
          onPressed: () => _submit(context: context, ref: ref),
        ),
      ],
    );
  }

  void _submit({required BuildContext context, required WidgetRef ref}) {
    final formState = ref.read(reserveFormProvider);

    if (formState.selectedRoomId == null) {
      _showError(context, 'Please select a room.');
      return;
    }
    if (formState.selectedPrepareTime == null) {
      _showError(context, 'Please select prepare time.');
      return;
    }
    if (formState.selectedCollectTime == null) {
      _showError(context, 'Please select collect time.');
      return;
    }
    final personsCount = formState.parsedPersonsCount;
    if (personsCount == null) {
      _showError(context, 'Persons count must be a number greater than 0.');
      return;
    }
    if (!formState.hasAnyDrink) {
      _showError(context, 'Please add at least one drink.');
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
      _showError(context, 'Collect time must be after prepare time.');
      return;
    }

    final task = ReserveToTaskMapper.mapDrinks(
      DrinksReserveInput(
        roomName: selectedRoom.name,
        prepareTime: prepareTime,
        collectTime: collectTime,
        personsCount: personsCount,
        drinkQuantities: formState.drinkQuantities,
      ),
    );

    ref.read(tasksProvider.notifier).addTask(task);
    ref.read(reserveFormProvider.notifier).reset();
    ref.read(reserveRequestTypeProvider.notifier).clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Drinks reservation added to Aufgaben.')),
    );
  }
}

class _FoodSetupReserveForm extends ConsumerWidget {
  const _FoodSetupReserveForm({required this.rooms});

  final List<Room> rooms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(foodSetupFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ReserveSectionHeader(title: 'Food Setup Request'),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                key: ValueKey(
                  'setup_room_${formState.selectedRoomId ?? 'none'}',
                ),
                initialValue: formState.selectedRoomId,
                decoration: const InputDecoration(labelText: 'Select Room'),
                items: rooms
                    .map(
                      (room) => DropdownMenuItem<String>(
                        value: room.id,
                        child: Text(room.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  ref.read(foodSetupFormProvider.notifier).setRoom(value);
                },
              ),
              const SizedBox(height: 10),
              _TimeField(
                labelText: 'Prepare Time',
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
                labelText: 'Collect Time',
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
                decoration: const InputDecoration(
                  labelText: 'Number of People',
                ),
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
              const ReserveSectionHeader(title: 'Service Setup Items'),
              const SizedBox(height: 6),
              ...AppConstants.foodSetupDefinitions.map((item) {
                final quantity = formState.itemQuantities[item.id] ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
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
          label: 'Create Food Setup Aufgabe',
          onPressed: () => _submit(context: context, ref: ref),
        ),
      ],
    );
  }

  void _submit({required BuildContext context, required WidgetRef ref}) {
    final formState = ref.read(foodSetupFormProvider);

    if (formState.selectedRoomId == null) {
      _showError(context, 'Please select a room.');
      return;
    }
    if (formState.selectedPrepareTime == null) {
      _showError(context, 'Please select prepare time.');
      return;
    }
    if (formState.selectedCollectTime == null) {
      _showError(context, 'Please select collect time.');
      return;
    }
    final personsCount = formState.parsedPersonsCount;
    if (personsCount == null) {
      _showError(context, 'Persons count must be a number greater than 0.');
      return;
    }
    if (!formState.hasAnyItem) {
      _showError(context, 'Please add at least one setup item.');
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
      _showError(context, 'Collect time must be after prepare time.');
      return;
    }

    final task = ReserveToTaskMapper.mapFoodSetup(
      FoodSetupReserveInput(
        roomName: selectedRoom.name,
        prepareTime: prepareTime,
        collectTime: collectTime,
        personsCount: personsCount,
        itemQuantities: formState.itemQuantities,
      ),
    );

    ref.read(tasksProvider.notifier).addTask(task);
    ref.read(foodSetupFormProvider.notifier).reset();
    ref.read(reserveRequestTypeProvider.notifier).clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Food setup request added to Aufgaben.')),
    );
  }
}

class _NoteReserveForm extends ConsumerWidget {
  const _NoteReserveForm({required this.rooms});

  final List<Room> rooms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(noteFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ReserveSectionHeader(title: 'Note Request'),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                key: ValueKey(
                  'note_room_${formState.selectedRoomId ?? 'none'}',
                ),
                initialValue: formState.selectedRoomId,
                decoration: const InputDecoration(labelText: 'Select Room'),
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
                labelText: 'Prepare Time',
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
                labelText: 'Collect Time',
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
                decoration: const InputDecoration(
                  labelText: 'Title (optional)',
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
                decoration: const InputDecoration(
                  labelText: 'Note / Description',
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
          label: 'Create Note Aufgabe',
          onPressed: () => _submit(context: context, ref: ref),
        ),
      ],
    );
  }

  void _submit({required BuildContext context, required WidgetRef ref}) {
    final formState = ref.read(noteFormProvider);

    if (formState.selectedRoomId == null) {
      _showError(context, 'Please select a room.');
      return;
    }
    if (formState.selectedPrepareTime == null) {
      _showError(context, 'Please select prepare time.');
      return;
    }
    if (formState.selectedCollectTime == null) {
      _showError(context, 'Please select collect time.');
      return;
    }
    if (formState.noteInput.trim().isEmpty) {
      _showError(context, 'Note / description is required.');
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
      _showError(context, 'Collect time must be after prepare time.');
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note request added to Aufgaben.')),
    );
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
    final label = selectedTime == null
        ? 'Select time'
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

DateTime _composeReservationDateTime(
  TimeOfDay selectedTime, {
  DateTime? baseDate,
}) {
  final dateBase = baseDate ?? DateTime.now();
  final now = DateTime.now();
  var scheduled = DateTime(
    dateBase.year,
    dateBase.month,
    dateBase.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  if (baseDate == null && scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}

void _showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
