enum DirectSellStep { stockSetup, cashier, summary }

extension DirectSellStepPresentation on DirectSellStep {
  String get label {
    switch (this) {
      case DirectSellStep.stockSetup:
        return 'Stock Setup';
      case DirectSellStep.cashier:
        return 'Selling';
      case DirectSellStep.summary:
        return 'Summary';
    }
  }
}

enum SnackyProductCategory {
  sandwichesBrotchen,
  bakerySweet,
  snacksSweets,
  drinks,
  extrasOther,
}

extension SnackyProductCategoryPresentation on SnackyProductCategory {
  String get label {
    switch (this) {
      case SnackyProductCategory.sandwichesBrotchen:
        return 'Sandwiches / Brotchen';
      case SnackyProductCategory.bakerySweet:
        return 'Bakery / Sweet';
      case SnackyProductCategory.snacksSweets:
        return 'Snacks / Sweets';
      case SnackyProductCategory.drinks:
        return 'Drinks';
      case SnackyProductCategory.extrasOther:
        return 'Extras / Other';
    }
  }
}

class SnackyCatalogItem {
  const SnackyCatalogItem({
    required this.id,
    required this.name,
    required this.category,
    required this.defaultPrice,
    this.isSpecialEntry = false,
  });

  final String id;
  final String name;
  final SnackyProductCategory category;
  final double defaultPrice;
  final bool isSpecialEntry;
}

class SnackySaleLine {
  const SnackySaleLine({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
  });

  final String itemId;
  final String itemName;
  final int quantity;
  final double unitPrice;

  double get lineTotal => unitPrice * quantity;
}

class SnackySale {
  const SnackySale({
    required this.id,
    required this.lines,
    required this.totalAmount,
    required this.paidAmount,
    required this.changeAmount,
    required this.createdAt,
  });

  final String id;
  final List<SnackySaleLine> lines;
  final double totalAmount;
  final double paidAmount;
  final double changeAmount;
  final DateTime createdAt;
}

class DirectSellSessionState {
  const DirectSellSessionState({
    required this.step,
    required this.unitPrices,
    required this.startingQuantities,
    required this.soldQuantities,
    required this.basketQuantities,
    required this.sales,
  });

  factory DirectSellSessionState.initial() {
    final unitPrices = <String, double>{};
    final startingQuantities = <String, int>{};
    final soldQuantities = <String, int>{};

    for (final item in snackyCatalogItems) {
      unitPrices[item.id] = item.defaultPrice;
      startingQuantities[item.id] = 0;
      soldQuantities[item.id] = 0;
    }

    return DirectSellSessionState(
      step: DirectSellStep.stockSetup,
      unitPrices: unitPrices,
      startingQuantities: startingQuantities,
      soldQuantities: soldQuantities,
      basketQuantities: const <String, int>{},
      sales: const <SnackySale>[],
    );
  }

  final DirectSellStep step;
  final Map<String, double> unitPrices;
  final Map<String, int> startingQuantities;
  final Map<String, int> soldQuantities;
  final Map<String, int> basketQuantities;
  final List<SnackySale> sales;

  DirectSellSessionState copyWith({
    DirectSellStep? step,
    Map<String, double>? unitPrices,
    Map<String, int>? startingQuantities,
    Map<String, int>? soldQuantities,
    Map<String, int>? basketQuantities,
    List<SnackySale>? sales,
  }) {
    return DirectSellSessionState(
      step: step ?? this.step,
      unitPrices: unitPrices ?? this.unitPrices,
      startingQuantities: startingQuantities ?? this.startingQuantities,
      soldQuantities: soldQuantities ?? this.soldQuantities,
      basketQuantities: basketQuantities ?? this.basketQuantities,
      sales: sales ?? this.sales,
    );
  }
}

extension DirectSellSessionStatePresentation on DirectSellSessionState {
  bool get hasAnyStockConfigured =>
      startingQuantities.values.any((quantity) => quantity > 0);

  int get totalTransactions => sales.length;

  int get totalSoldItems =>
      soldQuantities.values.fold<int>(0, (sum, quantity) => sum + quantity);

  int get totalStartingItems =>
      startingQuantities.values.fold<int>(0, (sum, quantity) => sum + quantity);

  int get totalRemainingItems => totalStartingItems - totalSoldItems;

  double get totalRevenue =>
      sales.fold<double>(0, (sum, sale) => sum + sale.totalAmount);
}

const snackyCatalogItems = <SnackyCatalogItem>[
  SnackyCatalogItem(
    id: 'ei_hartgekocht',
    name: 'Ei hartgekocht',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 0.60,
  ),
  SnackyCatalogItem(
    id: 'brotchen_trocken',
    name: 'Brotchen trocken',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 0.50,
  ),
  SnackyCatalogItem(
    id: 'obststucke',
    name: 'Obststucke',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 0.80,
  ),
  SnackyCatalogItem(
    id: 'salatbowl',
    name: 'Salatbowl',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 5.70,
  ),
  SnackyCatalogItem(
    id: 'kase_brotchen',
    name: 'Kase Brotchen',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 1.40,
  ),
  SnackyCatalogItem(
    id: 'salami_brotchen',
    name: 'Salami Brotchen',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 1.40,
  ),
  SnackyCatalogItem(
    id: 'wurst_brotchen',
    name: 'Wurst Brotchen',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 1.40,
  ),
  SnackyCatalogItem(
    id: 'leberwurst_brotchen',
    name: 'Leberwurst Brotchen',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 1.40,
  ),
  SnackyCatalogItem(
    id: 'schinken_pute_brotchen',
    name: 'Schinken, Pute Brotchen',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 1.50,
  ),
  SnackyCatalogItem(
    id: 'mett_brotchen',
    name: 'Mett Brotchen',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 1.60,
  ),
  SnackyCatalogItem(
    id: 'brot_div_belegt',
    name: 'Brot div. Belegt',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 2.20,
  ),
  SnackyCatalogItem(
    id: 'spezial_brotchen',
    name: 'Spezial Brotchen',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 2.80,
  ),
  SnackyCatalogItem(
    id: 'krusti_focaccia_laugenecken',
    name: 'Krusti, Focaccia, Laugenecken',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 3.50,
  ),
  SnackyCatalogItem(
    id: 'wiener_mit_brotchen',
    name: 'Wiener mit Brotchen',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 2.70,
  ),
  SnackyCatalogItem(
    id: 'fleischkase_mit_brotchen',
    name: 'Fleischkase mit Brotchen',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 2.70,
  ),
  SnackyCatalogItem(
    id: 'brat_rindswurst',
    name: 'Brat/Rindswurst',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 2.90,
  ),
  SnackyCatalogItem(
    id: 'frikadelle_mit_brotchen',
    name: 'Frikadelle mit Brotchen',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 3.10,
  ),
  SnackyCatalogItem(
    id: 'senf',
    name: 'Senf',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 0.10,
  ),
  SnackyCatalogItem(
    id: 'ketchup_majo',
    name: 'Ketchup, Majo',
    category: SnackyProductCategory.sandwichesBrotchen,
    defaultPrice: 0.40,
  ),
  SnackyCatalogItem(
    id: 'einback_rosinen_schokobrotchen',
    name: 'Einback, Rosinen, Schokobrotchen',
    category: SnackyProductCategory.bakerySweet,
    defaultPrice: 1.30,
  ),
  SnackyCatalogItem(
    id: 'verschiedene_teilchen',
    name: 'Verschiedene Teilchen',
    category: SnackyProductCategory.bakerySweet,
    defaultPrice: 1.80,
  ),
  SnackyCatalogItem(
    id: 'nussecke',
    name: 'Nussecke',
    category: SnackyProductCategory.bakerySweet,
    defaultPrice: 2.00,
  ),
  SnackyCatalogItem(
    id: 'kinder_bueno',
    name: 'Kinder Bueno',
    category: SnackyProductCategory.snacksSweets,
    defaultPrice: 1.50,
  ),
  SnackyCatalogItem(
    id: 'snickers_mars_nuts_twix',
    name: 'Snickers, Mars, Nuts, Twix, etc.',
    category: SnackyProductCategory.snacksSweets,
    defaultPrice: 1.20,
  ),
  SnackyCatalogItem(
    id: 'frucht_buttermilch',
    name: 'Frucht Buttermilch, Buttermilch',
    category: SnackyProductCategory.drinks,
    defaultPrice: 1.50,
  ),
  SnackyCatalogItem(
    id: 'joghurt_frucht_natur',
    name: 'Joghurt Frucht, Natur',
    category: SnackyProductCategory.drinks,
    defaultPrice: 0.90,
  ),
  SnackyCatalogItem(
    id: 'kakao_milch_eiskaffee',
    name: 'Kakao, Milch, Eiskaffee 0,5l',
    category: SnackyProductCategory.drinks,
    defaultPrice: 1.30,
  ),
  SnackyCatalogItem(
    id: 'vio_wasser',
    name: 'Vio Wasser',
    category: SnackyProductCategory.drinks,
    defaultPrice: 1.05,
  ),
  SnackyCatalogItem(
    id: 'red_bull',
    name: 'Red Bull',
    category: SnackyProductCategory.drinks,
    defaultPrice: 1.80,
  ),
  SnackyCatalogItem(
    id: 'pfand_pet_redbull',
    name: 'Pfand zuruck (PET, Red Bull)',
    category: SnackyProductCategory.extrasOther,
    defaultPrice: -0.25,
    isSpecialEntry: true,
  ),
  SnackyCatalogItem(
    id: 'pfand_salatschussel',
    name: 'Pfand zuruck (Salatschussel)',
    category: SnackyProductCategory.extrasOther,
    defaultPrice: -5.00,
    isSpecialEntry: true,
  ),
];
