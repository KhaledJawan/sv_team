import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../models/task_category.dart';
import '../../models/task_status.dart';

extension BuildContextL10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension TaskStatusL10nX on TaskStatus {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case TaskStatus.pending:
        return l10n.taskStatusPending;
      case TaskStatus.prepared:
        return l10n.taskStatusPrepared;
      case TaskStatus.done:
        return l10n.taskStatusDone;
      case TaskStatus.problem:
        return l10n.taskStatusProblem;
    }
  }
}

extension TaskCategoryL10nX on TaskCategory {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case TaskCategory.drinks:
        return l10n.taskCategoryDrinks;
      case TaskCategory.foodSetup:
        return l10n.taskCategoryFoodSetup;
      case TaskCategory.note:
        return l10n.taskCategoryNote;
      case TaskCategory.snacky:
        return l10n.taskCategorySnacky;
      case TaskCategory.others:
        return l10n.taskCategoryOthers;
    }
  }
}
