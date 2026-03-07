class AppDrinkDefinition {
  const AppDrinkDefinition({required this.id, required this.name});

  final String id;
  final String name;
}

class AppSetupItemDefinition {
  const AppSetupItemDefinition({required this.id, required this.name});

  final String id;
  final String name;
}

class AppConstants {
  AppConstants._();

  static const roomNames = <String>[
    'Room 001',
    'Room 002',
    'Room 003',
    'Room 004',
    'Room 005',
    'Room 006',
    'Room 007',
    'Room 008',
    'Room 009',
    'Room 010',
  ];

  static const drinkDefinitions = <AppDrinkDefinition>[
    AppDrinkDefinition(id: 'coca_cola', name: 'Coca-Cola'),
    AppDrinkDefinition(id: 'fanta', name: 'Fanta'),
    AppDrinkDefinition(id: 'water', name: 'Water'),
    AppDrinkDefinition(id: 'coffee', name: 'Coffee'),
    AppDrinkDefinition(id: 'tea', name: 'Tea'),
    AppDrinkDefinition(id: 'juice', name: 'Juice'),
  ];

  static const foodSetupDefinitions = <AppSetupItemDefinition>[
    AppSetupItemDefinition(id: 'plates', name: 'Plates'),
    AppSetupItemDefinition(id: 'forks', name: 'Forks'),
    AppSetupItemDefinition(id: 'knives', name: 'Knives'),
    AppSetupItemDefinition(id: 'spoons', name: 'Spoons'),
    AppSetupItemDefinition(id: 'small_spoons', name: 'Small spoons'),
    AppSetupItemDefinition(id: 'bowls', name: 'Bowls'),
    AppSetupItemDefinition(id: 'napkins', name: 'Napkins'),
    AppSetupItemDefinition(id: 'glasses', name: 'Glasses'),
    AppSetupItemDefinition(id: 'cups', name: 'Cups'),
  ];
}
