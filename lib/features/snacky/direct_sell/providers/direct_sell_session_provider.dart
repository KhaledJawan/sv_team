import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/snacky_session_repository.dart';
import '../models/direct_sell_models.dart';

class DirectSellSessionNotifier extends Notifier<DirectSellSessionState> {
  @override
  DirectSellSessionState build() {
    final persisted = ref.read(snackySessionRepositoryProvider).loadSession();
    return persisted ?? DirectSellSessionState.initial();
  }

  double unitPriceOf(String itemId) {
    return state.unitPrices[itemId] ?? 0;
  }

  int startingQuantityOf(String itemId) {
    return state.startingQuantities[itemId] ?? 0;
  }

  int soldQuantityOf(String itemId) {
    return state.soldQuantities[itemId] ?? 0;
  }

  int remainingQuantityOf(String itemId) {
    return startingQuantityOf(itemId) - soldQuantityOf(itemId);
  }

  int basketQuantityOf(String itemId) {
    return state.basketQuantities[itemId] ?? 0;
  }

  int availableToAddToBasket(String itemId) {
    final remaining = remainingQuantityOf(itemId);
    final alreadyInBasket = basketQuantityOf(itemId);
    final available = remaining - alreadyInBasket;
    return available < 0 ? 0 : available;
  }

  double basketSubtotal() {
    return state.basketQuantities.entries.fold<double>(0, (sum, entry) {
      final price = unitPriceOf(entry.key);
      return sum + (price * entry.value);
    });
  }

  bool get canOpenCashier => state.hasAnyStockConfigured;

  void setStep(DirectSellStep step) {
    _setState(state.copyWith(step: step));
  }

  String? moveToCashier() {
    if (!canOpenCashier) {
      return 'Add at least one item quantity before continuing.';
    }
    _setState(state.copyWith(step: DirectSellStep.cashier));
    return null;
  }

  String? moveToSummary() {
    if (state.basketQuantities.values.any((quantity) => quantity > 0)) {
      return 'Finish payment or clear basket before closing the session.';
    }
    _setState(state.copyWith(step: DirectSellStep.summary));
    return null;
  }

  void backToStock() {
    _setState(state.copyWith(step: DirectSellStep.stockSetup));
  }

  void backToCashier() {
    _setState(state.copyWith(step: DirectSellStep.cashier));
  }

  void resetSession() {
    _setState(DirectSellSessionState.initial());
  }

  void setStartingQuantity(String itemId, int quantity) {
    final safeQuantity = quantity < 0 ? 0 : quantity;
    final minimumAllowed = soldQuantityOf(itemId);
    final correctedQuantity = safeQuantity < minimumAllowed
        ? minimumAllowed
        : safeQuantity;

    final updated = Map<String, int>.from(state.startingQuantities);
    updated[itemId] = correctedQuantity;
    _setState(state.copyWith(startingQuantities: updated));

    final maxBasketAllowed = availableToAddToBasket(itemId);
    if (maxBasketAllowed == 0 && basketQuantityOf(itemId) > 0) {
      setBasketQuantity(itemId, 0);
    }
  }

  void incrementStartingQuantity(String itemId) {
    setStartingQuantity(itemId, startingQuantityOf(itemId) + 1);
  }

  void decrementStartingQuantity(String itemId) {
    setStartingQuantity(itemId, startingQuantityOf(itemId) - 1);
  }

  void setUnitPrice(String itemId, double value) {
    final updated = Map<String, double>.from(state.unitPrices);
    updated[itemId] = value;
    _setState(state.copyWith(unitPrices: updated));
  }

  void addItemToBasket(String itemId) {
    if (availableToAddToBasket(itemId) <= 0) {
      return;
    }
    setBasketQuantity(itemId, basketQuantityOf(itemId) + 1);
  }

  void incrementBasketQuantity(String itemId) {
    setBasketQuantity(itemId, basketQuantityOf(itemId) + 1);
  }

  void decrementBasketQuantity(String itemId) {
    setBasketQuantity(itemId, basketQuantityOf(itemId) - 1);
  }

  void setBasketQuantity(String itemId, int quantity) {
    final safeQuantity = quantity < 0 ? 0 : quantity;
    final maxAllowed = remainingQuantityOf(itemId);
    final correctedQuantity = safeQuantity > maxAllowed
        ? maxAllowed
        : safeQuantity;

    final updated = Map<String, int>.from(state.basketQuantities);
    if (correctedQuantity == 0) {
      updated.remove(itemId);
    } else {
      updated[itemId] = correctedQuantity;
    }

    _setState(state.copyWith(basketQuantities: updated));
  }

  void clearBasket() {
    _setState(state.copyWith(basketQuantities: const <String, int>{}));
  }

  String? confirmPayment({required double paidAmount}) {
    final basket = state.basketQuantities;
    if (basket.isEmpty) {
      return 'Basket is empty.';
    }

    final total = basketSubtotal();
    if (paidAmount < total) {
      return 'Paid amount is less than total.';
    }

    final soldQuantities = Map<String, int>.from(state.soldQuantities);
    final saleLines = <SnackySaleLine>[];

    for (final entry in basket.entries) {
      final catalogItem = snackyCatalogItems.where((it) => it.id == entry.key);
      if (catalogItem.isEmpty) {
        continue;
      }
      final item = catalogItem.first;
      final quantity = entry.value;
      soldQuantities[item.id] = (soldQuantities[item.id] ?? 0) + quantity;
      saleLines.add(
        SnackySaleLine(
          itemId: item.id,
          itemName: item.name,
          quantity: quantity,
          unitPrice: unitPriceOf(item.id),
        ),
      );
    }

    final updatedSales = [...state.sales];
    updatedSales.insert(
      0,
      SnackySale(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        lines: saleLines,
        totalAmount: total,
        paidAmount: paidAmount,
        changeAmount: paidAmount - total,
        createdAt: DateTime.now(),
      ),
    );

    _setState(
      state.copyWith(
        soldQuantities: soldQuantities,
        sales: updatedSales,
        basketQuantities: const <String, int>{},
      ),
    );

    return null;
  }

  void _setState(DirectSellSessionState nextState) {
    state = nextState;
    unawaited(ref.read(snackySessionRepositoryProvider).saveSession(nextState));
  }
}

final directSellSessionProvider =
    NotifierProvider<DirectSellSessionNotifier, DirectSellSessionState>(
      DirectSellSessionNotifier.new,
    );
