import 'package:flutter/material.dart';

import '../../../shared/widgets/app_segmented_control.dart';
import '../providers/operations_segment_provider.dart';

class OperationsTopBar extends StatelessWidget {
  const OperationsTopBar({
    super.key,
    required this.selectedSegment,
    required this.onSegmentChanged,
    required this.onNotificationTap,
  });

  final OperationsSegment selectedSegment;
  final ValueChanged<OperationsSegment> onSegmentChanged;
  final VoidCallback onNotificationTap;

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
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notifications',
          ),
        ],
      ),
    );
  }
}
