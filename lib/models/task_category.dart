import 'package:flutter/material.dart';

enum TaskCategory { drinks, foodSetup, note, snacky, others }

extension TaskCategoryPresentation on TaskCategory {
  String get label {
    switch (this) {
      case TaskCategory.drinks:
        return 'Drinks';
      case TaskCategory.foodSetup:
        return 'Food Setup';
      case TaskCategory.note:
        return 'Note';
      case TaskCategory.snacky:
        return 'Snacky';
      case TaskCategory.others:
        return 'Others';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskCategory.drinks:
        return Icons.local_cafe_outlined;
      case TaskCategory.foodSetup:
        return Icons.restaurant_outlined;
      case TaskCategory.note:
        return Icons.sticky_note_2_outlined;
      case TaskCategory.snacky:
        return Icons.fastfood_outlined;
      case TaskCategory.others:
        return Icons.more_horiz;
    }
  }
}
