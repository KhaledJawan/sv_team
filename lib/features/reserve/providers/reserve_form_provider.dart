import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';

class ReserveFormState {
  const ReserveFormState({
    required this.selectedRoomId,
    required this.selectedPrepareTime,
    required this.selectedCollectTime,
    required this.personsInput,
    required this.drinkQuantities,
  });

  factory ReserveFormState.initial() {
    return ReserveFormState(
      selectedRoomId: null,
      selectedPrepareTime: null,
      selectedCollectTime: null,
      personsInput: '1',
      drinkQuantities: {
        for (final drink in AppConstants.drinkDefinitions) drink.id: 0,
      },
    );
  }

  final String? selectedRoomId;
  final TimeOfDay? selectedPrepareTime;
  final TimeOfDay? selectedCollectTime;
  final String personsInput;
  final Map<String, int> drinkQuantities;

  int? get parsedPersonsCount {
    final value = int.tryParse(personsInput.trim());
    if (value == null || value < 1) {
      return null;
    }
    return value;
  }

  bool get hasAnyDrink =>
      drinkQuantities.values.any((quantity) => quantity > 0);

  ReserveFormState copyWith({
    String? selectedRoomId,
    TimeOfDay? selectedPrepareTime,
    bool clearPrepareTime = false,
    TimeOfDay? selectedCollectTime,
    bool clearCollectTime = false,
    String? personsInput,
    Map<String, int>? drinkQuantities,
  }) {
    return ReserveFormState(
      selectedRoomId: selectedRoomId ?? this.selectedRoomId,
      selectedPrepareTime: clearPrepareTime
          ? null
          : selectedPrepareTime ?? this.selectedPrepareTime,
      selectedCollectTime: clearCollectTime
          ? null
          : selectedCollectTime ?? this.selectedCollectTime,
      personsInput: personsInput ?? this.personsInput,
      drinkQuantities: drinkQuantities ?? this.drinkQuantities,
    );
  }
}

class ReserveFormNotifier extends Notifier<ReserveFormState> {
  @override
  ReserveFormState build() => ReserveFormState.initial();

  void setRoom(String? roomId) {
    state = state.copyWith(selectedRoomId: roomId);
  }

  void setPrepareTime(TimeOfDay time) {
    state = state.copyWith(selectedPrepareTime: time);
  }

  void setCollectTime(TimeOfDay time) {
    state = state.copyWith(selectedCollectTime: time);
  }

  void setPersonsInput(String value) {
    state = state.copyWith(personsInput: value);
  }

  void incrementDrink(String drinkId) {
    final updated = Map<String, int>.from(state.drinkQuantities);
    updated[drinkId] = (updated[drinkId] ?? 0) + 1;
    state = state.copyWith(drinkQuantities: updated);
  }

  void setDrinkQuantity(String drinkId, int quantity) {
    final safeQuantity = quantity < 0 ? 0 : quantity;
    final updated = Map<String, int>.from(state.drinkQuantities);
    updated[drinkId] = safeQuantity;
    state = state.copyWith(drinkQuantities: updated);
  }

  void decrementDrink(String drinkId) {
    final updated = Map<String, int>.from(state.drinkQuantities);
    final current = updated[drinkId] ?? 0;
    updated[drinkId] = current > 0 ? current - 1 : 0;
    state = state.copyWith(drinkQuantities: updated);
  }

  void reset() {
    state = ReserveFormState.initial();
  }
}

final reserveFormProvider =
    NotifierProvider<ReserveFormNotifier, ReserveFormState>(
      ReserveFormNotifier.new,
    );
