class Room {
  const Room({required this.id, required this.name});

  final String id;
  final String name;

  Room copyWith({String? id, String? name}) {
    return Room(id: id ?? this.id, name: name ?? this.name);
  }
}
