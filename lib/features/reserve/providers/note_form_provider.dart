import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteFormState {
  const NoteFormState({
    required this.selectedRoomId,
    required this.selectedTime,
    required this.titleInput,
    required this.noteInput,
  });

  factory NoteFormState.initial() {
    return const NoteFormState(
      selectedRoomId: null,
      selectedTime: null,
      titleInput: '',
      noteInput: '',
    );
  }

  final String? selectedRoomId;
  final TimeOfDay? selectedTime;
  final String titleInput;
  final String noteInput;

  NoteFormState copyWith({
    String? selectedRoomId,
    TimeOfDay? selectedTime,
    bool clearTime = false,
    String? titleInput,
    String? noteInput,
  }) {
    return NoteFormState(
      selectedRoomId: selectedRoomId ?? this.selectedRoomId,
      selectedTime: clearTime ? null : selectedTime ?? this.selectedTime,
      titleInput: titleInput ?? this.titleInput,
      noteInput: noteInput ?? this.noteInput,
    );
  }
}

class NoteFormNotifier extends Notifier<NoteFormState> {
  @override
  NoteFormState build() => NoteFormState.initial();

  void setRoom(String? roomId) {
    state = state.copyWith(selectedRoomId: roomId);
  }

  void setTime(TimeOfDay time) {
    state = state.copyWith(selectedTime: time);
  }

  void setTitle(String title) {
    state = state.copyWith(titleInput: title);
  }

  void setNote(String note) {
    state = state.copyWith(noteInput: note);
  }

  void reset() {
    state = NoteFormState.initial();
  }
}

final noteFormProvider = NotifierProvider<NoteFormNotifier, NoteFormState>(
  NoteFormNotifier.new,
);
