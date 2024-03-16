import 'package:flutter/material.dart';
import 'package:timeedit/models/room.dart';

class RoomCalendarRow extends StatelessWidget {
  final Room room;

  const RoomCalendarRow({super.key, required this.room}); 

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(room.name),
        Expanded(
          child: ListView.builder(
            itemCount: 14,
            itemBuilder: (context, index) {
              return Container(
                width: 50,
                height: 50,
                color: Colors.blue,
                child: Text(' $index'),
              );
            },
          ),
        ),
      ],
    );
  }
}
