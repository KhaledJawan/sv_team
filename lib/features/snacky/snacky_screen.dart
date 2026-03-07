import 'package:flutter/material.dart';

import '../../shared/widgets/empty_state.dart';

class SnackyScreen extends StatelessWidget {
  const SnackyScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final content = const EmptyState(
      icon: Icons.fastfood_outlined,
      title: 'Snacky',
      subtitle: 'Snacky will be added in the next phase.',
    );

    if (embedded) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
        child: content,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Snacky')),
      body: Padding(padding: const EdgeInsets.all(16), child: content),
    );
  }
}
