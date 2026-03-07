import 'package:flutter/material.dart';

import '../../../core/extensions/date_time_extension.dart';
import '../../../models/task_category.dart';
import '../../../models/task_item.dart';
import '../../../models/task_status.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/status_indicator.dart';

enum TaskCardMenuAction { openEdit, changeStatus, delete }

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onMenuAction,
  });

  final TaskItem task;
  final VoidCallback onTap;
  final ValueChanged<TaskCardMenuAction> onMenuAction;

  @override
  Widget build(BuildContext context) {
    final peopleSummary = task.personsCount != null
        ? '${task.personsCount} persons'
        : 'No persons count';

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 66,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: task.status.color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.roomName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Text(
                          task.scheduledTime.hhMm,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      peopleSummary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          task.category.icon,
                          size: 16,
                          color: const Color(0xFF6E6E73),
                        ),
                        const SizedBox(width: 8),
                        StatusIndicator(status: task.status),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<TaskCardMenuAction>(
                tooltip: 'Task actions',
                position: PopupMenuPosition.under,
                icon: const Icon(Icons.more_vert, color: Color(0xFF7B7B82)),
                onSelected: onMenuAction,
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: TaskCardMenuAction.openEdit,
                    child: Text('Edit / Open'),
                  ),
                  PopupMenuItem(
                    value: TaskCardMenuAction.changeStatus,
                    child: Text('Change status'),
                  ),
                  PopupMenuItem(
                    value: TaskCardMenuAction.delete,
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
