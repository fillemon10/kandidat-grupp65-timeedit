import 'package:flutter/material.dart';
import 'package:timeedit/models/room.dart';

class RoomCalendarRow extends StatelessWidget {
  final Room room;

  const RoomCalendarRow({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      height: 40,
    );
  }
}
