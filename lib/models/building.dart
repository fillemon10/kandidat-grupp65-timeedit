import 'package:timeedit/models/room.dart';

class Building {
  Building({
    required this.id,
    required this.name,
    required this.rooms,
  });

  final String id;
  final String name;
  final List<Room> rooms;
}
