import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/router.dart';
import '../../core/localization/app_localizations_x.dart';
import '../../models/task_item.dart';
import '../../models/task_status.dart';
import '../../shared/widgets/empty_state.dart';
import 'providers/tasks_provider.dart';
import 'widgets/task_card.dart';

class AufgabenScreen extends ConsumerWidget {
  const AufgabenScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tasks = ref.watch(sortedTasksProvider);

    final body = tasks.isEmpty
        ? EmptyState(
            icon: Icons.fact_check_outlined,
            title: l10n.aufgabenEmptyTitle,
            subtitle: l10n.aufgabenEmptySubtitle,
          )
        : ListView.separated(
            itemCount: tasks.length,
            shrinkWrap: embedded,
            physics: embedded
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
            padding: EdgeInsets.only(bottom: embedded ? 0 : 120),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(
                task: task,
                onTap: () => _openTask(context, task),
                onMenuAction: (action) => _handleMenuAction(
                  context: context,
                  ref: ref,
                  task: task,
                  action: action,
                ),
              );
            },
          );

    if (embedded) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aufgabenTitle)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: body,
      ),
    );
  }

  void _openTask(BuildContext context, TaskItem task) {
    Navigator.pushNamed(context, AppRouter.taskDetail, arguments: task);
  }

  Future<void> _handleMenuAction({
    required BuildContext context,
    required WidgetRef ref,
    required TaskItem task,
    required TaskCardMenuAction action,
  }) async {
    final l10n = context.l10n;

    if (action == TaskCardMenuAction.openEdit) {
      _openTask(context, task);
      return;
    }

    if (action == TaskCardMenuAction.changeStatus) {
      final nextStatus = await _showStatusPickerDialog(
        context: context,
        initialStatus: task.status,
      );

      if (nextStatus != null && nextStatus != task.status) {
        ref
            .read(tasksProvider.notifier)
            .updateTaskStatus(taskId: task.id, status: nextStatus);
      }
      return;
    }

    final shouldDelete = await _showDeleteDialog(context);
    if (shouldDelete == true) {
      final deleted = ref.read(tasksProvider.notifier).deleteTask(task.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              deleted
                  ? l10n.aufgabenTaskDeleted
                  : l10n.aufgabenDailySnackNoDelete,
            ),
          ),
        );
      }
    }
  }

  Future<TaskStatus?> _showStatusPickerDialog({
    required BuildContext context,
    required TaskStatus initialStatus,
  }) async {
    final l10n = context.l10n;
    var selectedStatus = initialStatus;

    return showDialog<TaskStatus>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.aufgabenChangeStatusTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final status in TaskStatus.values)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        setState(() {
                          selectedStatus = status;
                        });
                      },
                      leading: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: status.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Text(status.localizedLabel(l10n)),
                      trailing: selectedStatus == status
                          ? const Icon(Icons.check, size: 18)
                          : null,
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.commonCancel),
                ),
                FilledButton(
                  onPressed: () =>
                      Navigator.of(dialogContext).pop(selectedStatus),
                  child: Text(l10n.commonSave),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.aufgabenDeleteTaskTitle),
          content: Text(l10n.aufgabenDeleteTaskBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.commonDelete),
            ),
          ],
        );
      },
    );
  }
}
