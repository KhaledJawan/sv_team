import 'package:flutter/material.dart';

class ReserveSectionHeader extends StatelessWidget {
  const ReserveSectionHeader({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (action case final Widget actionWidget) actionWidget,
      ],
    );
  }
}
