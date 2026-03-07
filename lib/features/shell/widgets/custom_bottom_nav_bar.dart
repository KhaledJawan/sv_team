import 'package:flutter/material.dart';

import '../providers/bottom_nav_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.selectedTab,
    required this.onSelect,
  });

  final ShellTab selectedTab;
  final ValueChanged<ShellTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: 92 + bottomInset,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 70 + bottomInset,
              padding: EdgeInsets.fromLTRB(18, 10, 18, bottomInset),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE9E9ED))),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 16,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _NavTabItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Manage',
                    selected: selectedTab == ShellTab.manage,
                    onTap: () => onSelect(ShellTab.manage),
                  ),
                  const Spacer(),
                  const SizedBox(width: 102),
                  const Spacer(),
                  _NavTabItem(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    selected: selectedTab == ShellTab.profile,
                    onTap: () => onSelect(ShellTab.profile),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _CenterActionButton(
                  selected: selectedTab == ShellTab.aufgaben,
                  onTap: () => onSelect(ShellTab.aufgaben),
                ),
                const SizedBox(height: 6),
                Text(
                  'Aufgaben',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: selectedTab == ShellTab.aufgaben
                        ? Colors.black
                        : const Color(0xFF6E6E73),
                    fontWeight: FontWeight.w600,
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

class _CenterActionButton extends StatelessWidget {
  const _CenterActionButton({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: selected ? Colors.black : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE3E3E7)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 12,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.fact_check_outlined,
            color: selected ? Colors.white : Colors.black,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _NavTabItem extends StatelessWidget {
  const _NavTabItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.black : const Color(0xFF6E6E73);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
