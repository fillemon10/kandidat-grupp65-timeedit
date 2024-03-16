class Room {
  Room({
    required this.bookable,
    required this.building,
    required this.campus,
    required this.floor,
    required this.name,
    required this.roomNumber,
    required this.size,
  });

  bool bookable;
  String building;
  String campus;
  int floor;
  String name;
  String roomNumber;
  int size;

  factory Room.fromMap(Map<String, dynamic> json) => Room(
        bookable: json["bookable"],
        building: json["building"],
        campus: json["campus"],
        floor: json["floor"],
        name: json["name"],
        roomNumber: json["room_number"],
        size: json["size"],
      );

  Map<String, dynamic> toMap() => {
        "bookable": bookable,
        "building": building,
        "campus": campus,
        "floor": floor,
        "name": name,
        "room_number": roomNumber,
        "size": size,
      };
}
