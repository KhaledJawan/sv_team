import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations_x.dart';
import '../../../core/localization/localized_catalog_names.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/quantity_stepper.dart';
import 'models/direct_sell_models.dart';
import 'providers/direct_sell_session_provider.dart';

class DirectSellView extends ConsumerWidget {
  const DirectSellView({super.key, required this.embedded});

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(directSellSessionProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, embedded ? 130 : 16),
      child: Column(
        children: [
          _StepHeader(currentStep: session.step),
          const SizedBox(height: 10),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: switch (session.step) {
                DirectSellStep.stockSetup => const _StockSetupStep(
                  key: ValueKey('direct_sell_stock_setup'),
                ),
                DirectSellStep.cashier => const _CashierStep(
                  key: ValueKey('direct_sell_cashier'),
                ),
                DirectSellStep.summary => const _SummaryStep(
                  key: ValueKey('direct_sell_summary'),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.currentStep});

  final DirectSellStep currentStep;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = DirectSellStep.values;

    return AppCard(
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Expanded(
              child: _StepItem(
                label: _directSellStepLabel(l10n, steps[i]),
                active: currentStep == steps[i],
                completed: currentStep.index > steps[i].index,
              ),
            ),
            if (i != steps.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: Color(0xFF8A8A90),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.label,
    required this.active,
    required this.completed,
  });

  final String label;
  final bool active;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final color = completed
        ? const Color(0xFF218A45)
        : active
        ? Colors.black
        : const Color(0xFF8A8A90);

    return Text(
      label,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: color,
        fontWeight: active || completed ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }
}

class _StockSetupStep extends ConsumerWidget {
  const _StockSetupStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final session = ref.watch(directSellSessionProvider);
    final notifier = ref.read(directSellSessionProvider.notifier);

    final byCategory = <SnackyProductCategory, List<SnackyCatalogItem>>{};
    for (final item in snackyCatalogItems) {
      byCategory.putIfAbsent(item.category, () => []).add(item);
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.directSellStockStepTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.directSellStockStepSubtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          for (final category in SnackyProductCategory.values) ...[
            _CategoryCard(
              title: _productCategoryLabel(l10n, category),
              children: byCategory[category]!
                  .map(
                    (item) => _StockItemRow(
                      item: item,
                      quantity: session.startingQuantities[item.id] ?? 0,
                      price: session.unitPrices[item.id] ?? item.defaultPrice,
                      soldQuantity: session.soldQuantities[item.id] ?? 0,
                      onQuantityChanged: (value) {
                        notifier.setStartingQuantity(item.id, value);
                      },
                      onIncrement: () {
                        notifier.incrementStartingQuantity(item.id);
                      },
                      onDecrement: () {
                        notifier.decrementStartingQuantity(item.id);
                      },
                      onPriceChanged: (value) {
                        notifier.setUnitPrice(item.id, value);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
          ],
          AppButton(
            label: l10n.commonNext,
            onPressed: () {
              final error = notifier.moveToCashier();
              if (error != null) {
                _showSnack(context, _translateDirectSellError(l10n, error));
              }
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _StockItemRow extends StatelessWidget {
  const _StockItemRow({
    required this.item,
    required this.quantity,
    required this.price,
    required this.soldQuantity,
    required this.onQuantityChanged,
    required this.onIncrement,
    required this.onDecrement,
    required this.onPriceChanged,
  });

  final SnackyCatalogItem item;
  final int quantity;
  final double price;
  final int soldQuantity;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<double> onPriceChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizedSnackyItemName(l10n, item.id, fallback: item.name),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (item.isSpecialEntry)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F4),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l10n.directSellSpecialTag,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF66666C),
                          ),
                        ),
                      ),
                    if (soldQuantity > 0) ...[
                      if (item.isSpecialEntry) const SizedBox(width: 6),
                      Text(
                        l10n.directSellSoldCount(soldQuantity),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 92,
            child: _PriceInputField(value: price, onChanged: onPriceChanged),
          ),
          const SizedBox(width: 8),
          QuantityStepper(
            value: quantity,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
            onChanged: onQuantityChanged,
          ),
        ],
      ),
    );
  }
}

class _PriceInputField extends StatefulWidget {
  const _PriceInputField({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  State<_PriceInputField> createState() => _PriceInputFieldState();
}

class _PriceInputFieldState extends State<_PriceInputField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _moneyRaw(widget.value));
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _PriceInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_focusNode.hasFocus) {
      return;
    }
    final next = _moneyRaw(widget.value);
    if (_controller.text != next) {
      _controller.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.right,
      decoration: const InputDecoration(
        isDense: true,
        prefixText: '€ ',
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      onChanged: (raw) {
        final parsed = _parseMoney(raw);
        if (parsed != null) {
          widget.onChanged(parsed);
        }
      },
    );
  }
}

class _CashierStep extends ConsumerWidget {
  const _CashierStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    ref.watch(directSellSessionProvider);
    final notifier = ref.read(directSellSessionProvider.notifier);

    final availableItems = snackyCatalogItems
        .where((item) => notifier.remainingQuantityOf(item.id) > 0)
        .toList();

    final basketItems = snackyCatalogItems
        .where((item) => notifier.basketQuantityOf(item.id) > 0)
        .toList();

    final subtotal = notifier.basketSubtotal();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.directSellCashierStepTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.directSellCashierStepSubtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.directSellAvailableItems,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (availableItems.isEmpty)
                  Text(l10n.directSellNoStock)
                else
                  ...availableItems.map((item) {
                    final availableNow = notifier.availableToAddToBasket(
                      item.id,
                    );
                    final remainingTotal = notifier.remainingQuantityOf(
                      item.id,
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        localizedSnackyItemName(
                                          l10n,
                                          item.id,
                                          fallback: item.name,
                                        ),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                    if (item.isSpecialEntry)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF2F2F4),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: Text(
                                          l10n.directSellSpecialTag,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF66666C),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${_money(notifier.unitPriceOf(item.id))} · ${l10n.directSellRemainingCount(remainingTotal)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 34,
                            child: FilledButton.tonal(
                              onPressed: availableNow > 0
                                  ? () {
                                      notifier.addItemToBasket(item.id);
                                    }
                                  : null,
                              child: Text(l10n.directSellAdd),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.directSellCurrentBasket,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (basketItems.isEmpty)
                  Text(l10n.directSellNoBasket)
                else
                  ...basketItems.map((item) {
                    final quantity = notifier.basketQuantityOf(item.id);
                    final price = notifier.unitPriceOf(item.id);
                    final lineTotal = quantity * price;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localizedSnackyItemName(
                                    l10n,
                                    item.id,
                                    fallback: item.name,
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${_money(price)} ${l10n.directSellEach}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          QuantityStepper(
                            value: quantity,
                            onIncrement: () {
                              notifier.incrementBasketQuantity(item.id);
                            },
                            onDecrement: () {
                              notifier.decrementBasketQuantity(item.id);
                            },
                            onChanged: (value) {
                              notifier.setBasketQuantity(item.id, value);
                            },
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 74,
                            child: Text(
                              _money(lineTotal),
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                const Divider(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.directSellSubtotal,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      _money(subtotal),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: notifier.backToStock,
                  child: Text(l10n.directSellBackToStock),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final error = notifier.moveToSummary();
                    if (error != null) {
                      _showSnack(
                        context,
                        _translateDirectSellError(l10n, error),
                      );
                    }
                  },
                  child: Text(l10n.commonDone),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: basketItems.isEmpty
                  ? null
                  : () async {
                      await _showPaymentDialog(
                        context: context,
                        ref: ref,
                        subtotal: subtotal,
                      );
                    },
              child: Text(l10n.commonPay),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showPaymentDialog({
  required BuildContext context,
  required WidgetRef ref,
  required double subtotal,
}) async {
  final paidAmount = await showDialog<double>(
    context: context,
    builder: (_) => _PaymentDialog(total: subtotal),
  );

  if (paidAmount == null || !context.mounted) {
    return;
  }

  final notifier = ref.read(directSellSessionProvider.notifier);
  final error = notifier.confirmPayment(paidAmount: paidAmount);
  if (error != null) {
    _showSnack(context, _translateDirectSellError(context.l10n, error));
    return;
  }

  _showSnack(
    context,
    context.l10n.directSellSaleSavedChange(_money(paidAmount - subtotal)),
  );
}

class _PaymentDialog extends StatefulWidget {
  const _PaymentDialog({required this.total});

  final double total;

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  late final TextEditingController _controller;
  double _paidAmount = 0;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _paidAmount = widget.total > 0 ? widget.total : 0.0;
    _controller = TextEditingController(text: _moneyRaw(_paidAmount));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    final l10n = context.l10n;
    FocusScope.of(context).unfocus();
    final parsed = _parseMoney(_controller.text.trim());
    if (parsed == null) {
      setState(() {
        _errorText = l10n.directSellErrorValidAmount;
      });
      return;
    }
    if (parsed < widget.total) {
      setState(() {
        _errorText = l10n.directSellErrorPaidLess;
      });
      return;
    }
    Navigator.of(context).pop(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final change = _paidAmount - widget.total;

    return AlertDialog(
      title: Text(l10n.directSellPaymentTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.directSellTotalAmount(_money(widget.total))),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.directSellCustomerGave,
                prefixText: '€ ',
                errorText: _errorText,
              ),
              onChanged: (raw) {
                final parsed = _parseMoney(raw);
                setState(() {
                  if (parsed == null) {
                    _errorText = l10n.directSellErrorValidAmount;
                    return;
                  }
                  _errorText = null;
                  _paidAmount = parsed;
                });
              },
            ),
            const SizedBox(height: 10),
            Text(
              l10n.directSellChangeAmount(_money(change)),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _confirm,
          child: Text(l10n.directSellConfirmPayment),
        ),
      ],
    );
  }
}

class _SummaryStep extends ConsumerWidget {
  const _SummaryStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final session = ref.watch(directSellSessionProvider);
    final notifier = ref.read(directSellSessionProvider.notifier);

    final summaryItems = snackyCatalogItems
        .where(
          (item) =>
              (session.startingQuantities[item.id] ?? 0) > 0 ||
              (session.soldQuantities[item.id] ?? 0) > 0,
        )
        .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.directSellSummaryStepTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.directSellSummaryStepSubtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              children: [
                _SummaryMetric(
                  label: l10n.directSellMetricTotalRevenue,
                  value: _money(session.totalRevenue),
                ),
                const Divider(height: 16),
                _SummaryMetric(
                  label: l10n.directSellMetricTotalTransactions,
                  value: '${session.totalTransactions}',
                ),
                const Divider(height: 16),
                _SummaryMetric(
                  label: l10n.directSellMetricTotalSoldItems,
                  value: '${session.totalSoldItems}',
                ),
                const Divider(height: 16),
                _SummaryMetric(
                  label: l10n.directSellMetricRemainingItems,
                  value: '${session.totalRemainingItems}',
                ),
                const Divider(height: 16),
                _SummaryMetric(
                  label: l10n.directSellMetricStartingQuantities,
                  value: '${session.totalStartingItems}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.directSellPerItemSummary,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (summaryItems.isEmpty)
                  Text(l10n.directSellNoSessionData)
                else ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.commonItem,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        width: 56,
                        child: Text(
                          l10n.commonStart,
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 56,
                        child: Text(
                          l10n.commonSold,
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 70,
                        child: Text(
                          l10n.commonRemain,
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ...summaryItems.map((item) {
                    final start = session.startingQuantities[item.id] ?? 0;
                    final sold = session.soldQuantities[item.id] ?? 0;
                    final remaining = start - sold;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              localizedSnackyItemName(
                                l10n,
                                item.id,
                                fallback: item.name,
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          SizedBox(
                            width: 56,
                            child: Text(
                              '$start',
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 56,
                            child: Text(
                              '$sold',
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 70,
                            child: Text(
                              '$remaining',
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: notifier.backToCashier,
                  child: Text(l10n.directSellBackToSelling),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: l10n.directSellNewSession,
                  onPressed: notifier.resetSession,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

String _translateDirectSellError(AppLocalizations l10n, String error) {
  if (error == 'Add at least one item quantity before continuing.') {
    return l10n.directSellMoveToCashierError;
  }
  if (error == 'Finish payment or clear basket before closing the session.') {
    return l10n.directSellMoveToSummaryError;
  }
  if (error == 'Basket is empty.') {
    return l10n.directSellBasketEmptyError;
  }
  if (error == 'Paid amount is less than total.') {
    return l10n.directSellErrorPaidLess;
  }
  return error;
}

String _directSellStepLabel(AppLocalizations l10n, DirectSellStep step) {
  switch (step) {
    case DirectSellStep.stockSetup:
      return l10n.directSellStepStockSetup;
    case DirectSellStep.cashier:
      return l10n.directSellStepSelling;
    case DirectSellStep.summary:
      return l10n.directSellStepSummary;
  }
}

String _productCategoryLabel(
  AppLocalizations l10n,
  SnackyProductCategory category,
) {
  switch (category) {
    case SnackyProductCategory.sandwichesBrotchen:
      return l10n.directSellCategorySandwiches;
    case SnackyProductCategory.bakerySweet:
      return l10n.directSellCategoryBakery;
    case SnackyProductCategory.snacksSweets:
      return l10n.directSellCategorySnacks;
    case SnackyProductCategory.drinks:
      return l10n.directSellCategoryDrinks;
    case SnackyProductCategory.extrasOther:
      return l10n.directSellCategoryExtras;
  }
}

double? _parseMoney(String raw) {
  final normalized = raw.trim().replaceAll(',', '.');
  if (normalized.isEmpty || normalized == '-' || normalized == '.') {
    return null;
  }
  return double.tryParse(normalized);
}

String _moneyRaw(double value) {
  return value.toStringAsFixed(2);
}

String _money(double value) {
  return '${value.toStringAsFixed(2)} €';
}
