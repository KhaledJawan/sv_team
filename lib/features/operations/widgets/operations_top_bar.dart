import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations_x.dart';
import '../../../shared/widgets/app_segmented_control.dart';
import '../providers/operations_segment_provider.dart';

class OperationsTopBar extends StatelessWidget {
  const OperationsTopBar({
    super.key,
    required this.selectedSegment,
    required this.onSegmentChanged,
    required this.onNotificationTap,
    required this.hasUnreadNotifications,
  });

  final OperationsSegment selectedSegment;
  final ValueChanged<OperationsSegment> onSegmentChanged;
  final VoidCallback onNotificationTap;
  final bool hasUnreadNotifications;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(
            child: AppSegmentedControl<OperationsSegment>(
              value: selectedSegment,
              options: [
                SegmentOption(
                  value: OperationsSegment.reserve,
                  label: l10n.manageReserve,
                ),
                SegmentOption(
                  value: OperationsSegment.snacky,
                  label: l10n.manageSnacky,
                ),
                SegmentOption(
                  value: OperationsSegment.others,
                  label: l10n.manageOthers,
                ),
              ],
              onChanged: onSegmentChanged,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onNotificationTap,
            tooltip: l10n.manageNotificationsTooltip,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded),
                if (hasUnreadNotifications)
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD93025),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
