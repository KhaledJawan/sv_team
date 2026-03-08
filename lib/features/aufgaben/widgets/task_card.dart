import 'package:flutter/material.dart';

import '../../../core/extensions/date_time_extension.dart';
import '../../../core/localization/app_localizations_x.dart';
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
    final l10n = context.l10n;
    final hasCollectTime = task.category != TaskCategory.snacky;
    final collectIsBold = task.status == TaskStatus.prepared;
    final showCollectAsPrimary = hasCollectTime && collectIsBold;
    final primaryDateTime = showCollectAsPrimary
        ? task.collectTime
        : task.prepareTime;
    final baseCollectStyle =
        Theme.of(context).textTheme.bodySmall ?? const TextStyle(fontSize: 12);
    final peopleSummary = task.personsCount != null
        ? l10n.taskPersons(task.personsCount!)
        : l10n.taskNoPersonsCount;

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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              primaryDateTime.ddMmYyyyOrTodayLabel(
                                l10n.commonToday,
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              showCollectAsPrimary
                                  ? l10n.taskCollectAt(task.collectTime.hhMm)
                                  : l10n.taskPrepAt(task.prepareTime.hhMm),
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            if (hasCollectTime) ...[
                              const SizedBox(height: 2),
                              Text(
                                showCollectAsPrimary
                                    ? l10n.taskPrepAt(task.prepareTime.hhMm)
                                    : l10n.taskCollectAt(task.collectTime.hhMm),
                                style: baseCollectStyle.copyWith(
                                  fontWeight: collectIsBold
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ],
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
                tooltip: l10n.taskActionsTooltip,
                position: PopupMenuPosition.under,
                icon: const Icon(Icons.more_vert, color: Color(0xFF7B7B82)),
                onSelected: onMenuAction,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: TaskCardMenuAction.openEdit,
                    child: Text(l10n.taskActionsOpenEdit),
                  ),
                  PopupMenuItem(
                    value: TaskCardMenuAction.changeStatus,
                    child: Text(l10n.taskActionsChangeStatus),
                  ),
                  PopupMenuItem(
                    value: TaskCardMenuAction.delete,
                    child: Text(l10n.commonDelete),
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
