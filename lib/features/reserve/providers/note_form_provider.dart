import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteFormState {
  const NoteFormState({
    required this.selectedRoomId,
    required this.selectedPrepareTime,
    required this.selectedCollectTime,
    required this.titleInput,
    required this.noteInput,
  });

  factory NoteFormState.initial() {
    return const NoteFormState(
      selectedRoomId: null,
      selectedPrepareTime: null,
      selectedCollectTime: null,
      titleInput: '',
      noteInput: '',
    );
  }

  final String? selectedRoomId;
  final TimeOfDay? selectedPrepareTime;
  final TimeOfDay? selectedCollectTime;
  final String titleInput;
  final String noteInput;

  NoteFormState copyWith({
    String? selectedRoomId,
    TimeOfDay? selectedPrepareTime,
    bool clearPrepareTime = false,
    TimeOfDay? selectedCollectTime,
    bool clearCollectTime = false,
    String? titleInput,
    String? noteInput,
  }) {
    return NoteFormState(
      selectedRoomId: selectedRoomId ?? this.selectedRoomId,
      selectedPrepareTime: clearPrepareTime
          ? null
          : selectedPrepareTime ?? this.selectedPrepareTime,
      selectedCollectTime: clearCollectTime
          ? null
          : selectedCollectTime ?? this.selectedCollectTime,
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

  void setPrepareTime(TimeOfDay time) {
    state = state.copyWith(selectedPrepareTime: time);
  }

  void setCollectTime(TimeOfDay time) {
    state = state.copyWith(selectedCollectTime: time);
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
