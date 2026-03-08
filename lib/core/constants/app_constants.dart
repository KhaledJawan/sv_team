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

  static const currentOperatorName = 'Khaled';

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
    AppDrinkDefinition(id: 'kaffee', name: 'Kaffee'),
    AppDrinkDefinition(id: 'tee', name: 'Tee'),
    AppDrinkDefinition(id: 'sprudel_07', name: 'Sprudel 0,7l'),
    AppDrinkDefinition(id: 'still_07', name: 'Still 0,7l'),
    AppDrinkDefinition(id: 'sprudel_025', name: 'Sprudel 0,25l'),
    AppDrinkDefinition(id: 'still_025', name: 'Still 0,25l'),
    AppDrinkDefinition(id: 'cola', name: 'Cola'),
    AppDrinkDefinition(id: 'cola_zero', name: 'Cola zero'),
    AppDrinkDefinition(id: 'mezzo_mix', name: 'Mezzo Mix'),
    AppDrinkDefinition(id: 'fanta', name: 'Fanta'),
    AppDrinkDefinition(id: 'saft_02', name: 'Saft 0,2l'),
    AppDrinkDefinition(id: 'gebaecksteller', name: 'Gebäcksteller'),
    AppDrinkDefinition(id: 'obst', name: 'Obst'),
    AppDrinkDefinition(id: 'sonstiges', name: 'Sonstiges'),
  ];

  static const foodSetupDefinitions = <AppSetupItemDefinition>[
    AppSetupItemDefinition(id: 'messer', name: 'Messer'),
    AppSetupItemDefinition(id: 'gabeln', name: 'Gabeln'),
    AppSetupItemDefinition(id: 'suppenloeffel', name: 'Suppenlöffel'),
    AppSetupItemDefinition(id: 'kleine_loeffel', name: 'Kleine Löffel'),
    AppSetupItemDefinition(id: 'kleine_gabel', name: 'Kleine Gabel'),
    AppSetupItemDefinition(id: 'servietten', name: 'Servietten'),
    AppSetupItemDefinition(id: 'kleine_teller', name: 'Kleine Teller'),
    AppSetupItemDefinition(id: 'mg_teller', name: 'mg. Teller'),
    AppSetupItemDefinition(id: 'suppenteller', name: 'Suppenteller'),
    AppSetupItemDefinition(id: 'zangen', name: 'Zangen'),
    AppSetupItemDefinition(id: 'kellen', name: 'Kellen'),
    AppSetupItemDefinition(id: 'sossenkelle', name: 'Soßenkelle'),
    AppSetupItemDefinition(id: 'suppenkelle', name: 'Suppenkelle'),
    AppSetupItemDefinition(id: 'chavies', name: 'Chavies'),
    AppSetupItemDefinition(id: 'suppenpaste', name: 'Suppenpaste'),
    AppSetupItemDefinition(id: 'brennpaste', name: 'Brennpaste'),
  ];
}
