import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(
            child: AppSegmentedControl<OperationsSegment>(
              value: selectedSegment,
              options: const [
                SegmentOption(
                  value: OperationsSegment.reserve,
                  label: 'Reserve',
                ),
                SegmentOption(value: OperationsSegment.snacky, label: 'Snacky'),
                SegmentOption(value: OperationsSegment.others, label: 'Others'),
              ],
              onChanged: onSegmentChanged,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onNotificationTap,
            tooltip: 'Notifications',
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
