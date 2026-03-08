import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations_x.dart';
import '../../../shared/widgets/empty_state.dart';

class SnackyOrdersPlaceholder extends StatelessWidget {
  const SnackyOrdersPlaceholder({super.key, required this.embedded});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, embedded ? 130 : 16),
      child: EmptyState(
        icon: Icons.receipt_long_outlined,
        title: l10n.snackyOptionOrdersTitle,
        subtitle: l10n.snackyOrdersPlaceholderSubtitle,
      ),
    );
  }
}
