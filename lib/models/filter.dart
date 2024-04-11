class Filter {
  String? building;
  String? campus;
  int? floor;
  String? name;
  int? size;

  Filter({this.building, this.campus, this.floor, this.name, this.size});

  Filter copyWith({
    String? building,
    String? campus,
    int? floor,
    String? name,
    int? size,
  }) {
    return Filter(
      building: building ?? this.building,
      campus: campus ?? this.campus,
      floor: floor ?? this.floor,
      name: name ?? this.name,
      size: size ?? this.size,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Filter &&
          runtimeType == other.runtimeType &&
          building == other.building &&
          campus == other.campus &&
          floor == other.floor &&
          name == other.name &&
          size == other.size;

  @override
  int get hashCode =>
      building.hashCode ^
      campus.hashCode ^
      floor.hashCode ^
      name.hashCode ^
      size.hashCode;
}
