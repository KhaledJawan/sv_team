import 'package:flutter/material.dart';

import '../../core/localization/app_localizations_x.dart';
import '../../shared/widgets/empty_state.dart';

class OthersScreen extends StatelessWidget {
  const OthersScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final content = EmptyState(
      icon: Icons.more_horiz,
      title: l10n.othersTitle,
      subtitle: l10n.othersSubtitle,
    );

    if (embedded) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
        child: content,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.othersTitle)),
      body: Padding(padding: const EdgeInsets.all(16), child: content),
    );
  }
}
