import 'package:flutter/material.dart';

enum TaskStatus { pending, done, problem }

extension TaskStatusPresentation on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.done:
        return 'Done';
      case TaskStatus.problem:
        return 'Problem';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.pending:
        return const Color(0xFFE68A00);
      case TaskStatus.done:
        return const Color(0xFF218A45);
      case TaskStatus.problem:
        return const Color(0xFFB3261E);
    }
  }
}
