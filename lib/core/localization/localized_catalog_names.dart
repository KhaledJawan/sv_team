import '../../l10n/app_localizations.dart';

bool _isEnglish(AppLocalizations l10n) => l10n.localeName.startsWith('en');

String localizedDrinkName(
  AppLocalizations l10n,
  String id, {
  required String fallback,
}) {
  if (!_isEnglish(l10n)) {
    return fallback;
  }

  return switch (id) {
    'kaffee' => 'Coffee',
    'tee' => 'Tea',
    'sprudel_07' => 'Sparkling Water 0.7L',
    'still_07' => 'Still Water 0.7L',
    'sprudel_025' => 'Sparkling Water 0.25L',
    'still_025' => 'Still Water 0.25L',
    'cola' => 'Cola',
    'cola_zero' => 'Cola Zero',
    'mezzo_mix' => 'Mezzo Mix',
    'fanta' => 'Fanta',
    'saft_02' => 'Juice 0.2L',
    'gebaecksteller' => 'Pastry Plate',
    'obst' => 'Fruit',
    'sonstiges' => 'Other',
    _ => fallback,
  };
}

String localizedFoodSetupName(
  AppLocalizations l10n,
  String id, {
  required String fallback,
}) {
  if (!_isEnglish(l10n)) {
    return fallback;
  }

  return switch (id) {
    'messer' => 'Knives',
    'gabeln' => 'Forks',
    'suppenloeffel' => 'Soup Spoons',
    'kleine_loeffel' => 'Small Spoons',
    'kleine_gabel' => 'Small Forks',
    'servietten' => 'Napkins',
    'kleine_teller' => 'Small Plates',
    'mg_teller' => 'Medium Plates',
    'suppenteller' => 'Soup Plates',
    'zangen' => 'Tongs',
    'kellen' => 'Ladles',
    'sossenkelle' => 'Sauce Ladle',
    'suppenkelle' => 'Soup Ladle',
    'chavies' => 'Chavies',
    'suppenpaste' => 'Soup Paste',
    'brennpaste' => 'Chafing Fuel',
    _ => fallback,
  };
}

String localizedDerivedItemName(
  AppLocalizations l10n,
  String id, {
  required String fallback,
}) {
  if (_isEnglish(l10n)) {
    return switch (id) {
      'cups' => 'Cups',
      'napkins' => 'Napkins',
      'glasses' => 'Glasses',
      _ => fallback,
    };
  }

  return switch (id) {
    'cups' => 'Tassen',
    'napkins' => 'Servietten',
    'glasses' => 'Gläser',
    _ => fallback,
  };
}

String localizedSnackyItemName(
  AppLocalizations l10n,
  String id, {
  required String fallback,
}) {
  if (!_isEnglish(l10n)) {
    return fallback;
  }

  return switch (id) {
    'ei_hartgekocht' => 'Boiled Egg',
    'brotchen_trocken' => 'Plain Bread Roll',
    'obststucke' => 'Fruit Pieces',
    'salatbowl' => 'Salad Bowl',
    'kase_brotchen' => 'Cheese Roll',
    'salami_brotchen' => 'Salami Roll',
    'wurst_brotchen' => 'Sausage Roll',
    'leberwurst_brotchen' => 'Liverwurst Roll',
    'schinken_pute_brotchen' => 'Ham/Turkey Roll',
    'mett_brotchen' => 'Mett Roll',
    'brot_div_belegt' => 'Assorted Topped Bread',
    'spezial_brotchen' => 'Special Roll',
    'krusti_focaccia_laugenecken' => 'Krusti/Focaccia/Pretzel Corner',
    'wiener_mit_brotchen' => 'Wiener with Roll',
    'fleischkase_mit_brotchen' => 'Meat Loaf with Roll',
    'brat_rindswurst' => 'Bratwurst/Beef Sausage',
    'frikadelle_mit_brotchen' => 'Meat Patty with Roll',
    'senf' => 'Mustard',
    'ketchup_majo' => 'Ketchup/Mayo',
    'einback_rosinen_schokobrotchen' => 'Sweet Roll/Raisin/Chocolate Roll',
    'verschiedene_teilchen' => 'Assorted Pastries',
    'nussecke' => 'Nut Corner',
    'kinder_bueno' => 'Kinder Bueno',
    'snickers_mars_nuts_twix' => 'Snickers/Mars/Nuts/Twix, etc.',
    'frucht_buttermilch' => 'Fruit Buttermilk/Buttermilk',
    'joghurt_frucht_natur' => 'Fruit Yogurt/Natural Yogurt',
    'kakao_milch_eiskaffee' => 'Cocoa/Milk/Iced Coffee 0.5L',
    'vio_wasser' => 'Vio Water',
    'red_bull' => 'Red Bull',
    'pfand_pet_redbull' => 'Deposit Return (PET, Red Bull)',
    'pfand_salatschussel' => 'Deposit Return (Salad Bowl)',
    _ => fallback,
  };
}
