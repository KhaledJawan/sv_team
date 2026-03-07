import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';

class FoodSetupFormState {
  const FoodSetupFormState({
    required this.selectedRoomId,
    required this.selectedPrepareTime,
    required this.selectedCollectTime,
    required this.personsInput,
    required this.itemQuantities,
  });

  factory FoodSetupFormState.initial() {
    return FoodSetupFormState(
      selectedRoomId: null,
      selectedPrepareTime: null,
      selectedCollectTime: null,
      personsInput: '1',
      itemQuantities: {
        for (final item in AppConstants.foodSetupDefinitions) item.id: 0,
      },
    );
  }

  final String? selectedRoomId;
  final TimeOfDay? selectedPrepareTime;
  final TimeOfDay? selectedCollectTime;
  final String personsInput;
  final Map<String, int> itemQuantities;

  int? get parsedPersonsCount {
    final value = int.tryParse(personsInput.trim());
    if (value == null || value < 1) {
      return null;
    }
    return value;
  }

  bool get hasAnyItem => itemQuantities.values.any((quantity) => quantity > 0);

  FoodSetupFormState copyWith({
    String? selectedRoomId,
    TimeOfDay? selectedPrepareTime,
    bool clearPrepareTime = false,
    TimeOfDay? selectedCollectTime,
    bool clearCollectTime = false,
    String? personsInput,
    Map<String, int>? itemQuantities,
  }) {
    return FoodSetupFormState(
      selectedRoomId: selectedRoomId ?? this.selectedRoomId,
      selectedPrepareTime: clearPrepareTime
          ? null
          : selectedPrepareTime ?? this.selectedPrepareTime,
      selectedCollectTime: clearCollectTime
          ? null
          : selectedCollectTime ?? this.selectedCollectTime,
      personsInput: personsInput ?? this.personsInput,
      itemQuantities: itemQuantities ?? this.itemQuantities,
    );
  }
}

class FoodSetupFormNotifier extends Notifier<FoodSetupFormState> {
  @override
  FoodSetupFormState build() => FoodSetupFormState.initial();

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

  void incrementItem(String itemId) {
    final updated = Map<String, int>.from(state.itemQuantities);
    updated[itemId] = (updated[itemId] ?? 0) + 1;
    state = state.copyWith(itemQuantities: updated);
  }

  void setItemQuantity(String itemId, int quantity) {
    final safeQuantity = quantity < 0 ? 0 : quantity;
    final updated = Map<String, int>.from(state.itemQuantities);
    updated[itemId] = safeQuantity;
    state = state.copyWith(itemQuantities: updated);
  }

  void decrementItem(String itemId) {
    final updated = Map<String, int>.from(state.itemQuantities);
    final current = updated[itemId] ?? 0;
    updated[itemId] = current > 0 ? current - 1 : 0;
    state = state.copyWith(itemQuantities: updated);
  }

  void reset() {
    state = FoodSetupFormState.initial();
  }
}

final foodSetupFormProvider =
    NotifierProvider<FoodSetupFormNotifier, FoodSetupFormState>(
      FoodSetupFormNotifier.new,
    );
