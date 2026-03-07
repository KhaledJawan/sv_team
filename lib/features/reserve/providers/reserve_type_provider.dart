import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ReserveRequestType { drinks, foodSetup, note }

extension ReserveRequestTypePresentation on ReserveRequestType {
  String get label {
    switch (this) {
      case ReserveRequestType.drinks:
        return 'Drinks';
      case ReserveRequestType.foodSetup:
        return 'Food Setup';
      case ReserveRequestType.note:
        return 'Note';
    }
  }
}

class ReserveRequestTypeNotifier extends Notifier<ReserveRequestType?> {
  @override
  ReserveRequestType? build() => null;

  void setType(ReserveRequestType type) {
    state = type;
  }

  void clear() {
    state = null;
  }
}

final reserveRequestTypeProvider =
    NotifierProvider<ReserveRequestTypeNotifier, ReserveRequestType?>(
      ReserveRequestTypeNotifier.new,
    );
