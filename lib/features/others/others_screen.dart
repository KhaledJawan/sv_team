import 'package:flutter/material.dart';

import '../../shared/widgets/empty_state.dart';

class OthersScreen extends StatelessWidget {
  const OthersScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final content = const EmptyState(
      icon: Icons.more_horiz,
      title: 'Others',
      subtitle: 'Others will be added in the next phase.',
    );

    if (embedded) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
        child: content,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Others')),
      body: Padding(padding: const EdgeInsets.all(16), child: content),
    );
  }
}
