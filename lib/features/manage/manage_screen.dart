import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/router.dart';
import '../notifications/providers/notifications_provider.dart';
import '../operations/providers/operations_segment_provider.dart';
import '../operations/widgets/operations_top_bar.dart';
import '../others/others_screen.dart';
import '../reserve/reserve_screen.dart';
import '../snacky/snacky_screen.dart';

class ManageScreen extends ConsumerWidget {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final segment = ref.watch(operationsSegmentProvider);
    final hasUnreadNotifications = ref.watch(hasUnreadNotificationsProvider);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          OperationsTopBar(
            selectedSegment: segment,
            onSegmentChanged: (value) {
              ref.read(operationsSegmentProvider.notifier).setSegment(value);
            },
            hasUnreadNotifications: hasUnreadNotifications,
            onNotificationTap: () {
              Navigator.pushNamed(context, AppRouter.notifications);
            },
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: switch (segment) {
                OperationsSegment.reserve => const ReserveScreen(
                  key: ValueKey('manage_reserve_segment'),
                ),
                OperationsSegment.snacky => const SnackyScreen(
                  key: ValueKey('manage_snacky_segment'),
                  embedded: true,
                ),
                OperationsSegment.others => const OthersScreen(
                  key: ValueKey('manage_others_segment'),
                  embedded: true,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
