import 'package:flutter/material.dart';

import '../../core/localization/app_localizations_x.dart';
import '../../models/task_status.dart';

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key, required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: status.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          status.localizedLabel(l10n),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
