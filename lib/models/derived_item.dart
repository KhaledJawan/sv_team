class DerivedItem {
  const DerivedItem({
    required this.id,
    required this.name,
    required this.quantity,
  });

  final String id;
  final String name;
  final int quantity;

  DerivedItem copyWith({String? id, String? name, int? quantity}) {
    return DerivedItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
    );
  }
}
