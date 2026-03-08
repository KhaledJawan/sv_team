import 'package:flutter/material.dart';

import '../../core/localization/app_localizations_x.dart';
import '../../shared/widgets/app_card.dart';
import 'direct_sell/direct_sell_view.dart';
import 'orders/snacky_orders_placeholder.dart';

class SnackyScreen extends StatelessWidget {
  const SnackyScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final content = SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 8, 16, embedded ? 130 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.snackyTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            l10n.snackyChoosePrompt,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          _OptionCard(
            icon: Icons.point_of_sale_outlined,
            title: l10n.snackyOptionDirectSellTitle,
            subtitle: l10n.snackyOptionDirectSellSubtitle,
            buttonLabel: l10n.snackyOpenDirectSell,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const _SnackyDirectSellPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _OptionCard(
            icon: Icons.receipt_long_outlined,
            title: l10n.snackyOptionOrdersTitle,
            subtitle: l10n.snackyOptionOrdersSubtitle,
            buttonLabel: l10n.snackyOpenOrders,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const _SnackyOrdersPage(),
                ),
              );
            },
          ),
        ],
      ),
    );

    if (embedded) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.snackyTitle)),
      body: content,
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: onTap, child: Text(buttonLabel)),
          ),
        ],
      ),
    );
  }
}

class _SnackyDirectSellPage extends StatelessWidget {
  const _SnackyDirectSellPage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.snackyDirectSellPageTitle)),
      body: const DirectSellView(embedded: false),
    );
  }
}

class _SnackyOrdersPage extends StatelessWidget {
  const _SnackyOrdersPage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.snackyOrdersPageTitle)),
      body: const SnackyOrdersPlaceholder(embedded: false),
    );
  }
}
