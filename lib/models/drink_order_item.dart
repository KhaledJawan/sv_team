class DrinkOrderItem {
  const DrinkOrderItem({
    required this.id,
    required this.name,
    required this.quantity,
  });

  final String id;
  final String name;
  final int quantity;

  DrinkOrderItem copyWith({String? id, String? name, int? quantity}) {
    return DrinkOrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
    );
  }
}
