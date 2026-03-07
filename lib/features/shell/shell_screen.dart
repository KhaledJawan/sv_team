import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../aufgaben/aufgaben_screen.dart';
import '../manage/manage_screen.dart';
import '../profile/profile_screen.dart';
import 'providers/bottom_nav_provider.dart';
import 'widgets/custom_bottom_nav_bar.dart';

class ShellScreen extends ConsumerWidget {
  const ShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(bottomNavProvider);

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentTab.index,
        children: const [ManageScreen(), AufgabenScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedTab: currentTab,
        onSelect: (tab) => ref.read(bottomNavProvider.notifier).select(tab),
      ),
    );
  }
}
