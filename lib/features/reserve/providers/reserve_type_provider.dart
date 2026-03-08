import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';

enum ReserveRequestType { drinks, foodSetup, note }

extension ReserveRequestTypePresentation on ReserveRequestType {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case ReserveRequestType.drinks:
        return l10n.reserveTypeDrinks;
      case ReserveRequestType.foodSetup:
        return l10n.reserveTypeFoodSetup;
      case ReserveRequestType.note:
        return l10n.reserveTypeNote;
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
