import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/models/room.dart';
import 'package:timeedit/widgets/booking_row.dart';
import 'package:timeedit/widgets/booking_tab_bar.dart';

const int AMOUNT_OF_DAYS = 14;

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: AMOUNT_OF_DAYS + 1,
      child: BookingTabBar(
        today: DateTime.now(),
      ),
    );
  }
}

class BuildingsTable extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final DateTime selectedDate;

  const BuildingsTable(
      {super.key, required this.bookingData, required this.selectedDate});

  @override
  State<BuildingsTable> createState() => _BuildingsTableState();
}

class _BuildingsTableState extends State<BuildingsTable> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.bookingData.keys.length,
      itemBuilder: (context, index) {
        final buildingName = widget.bookingData.keys.elementAt(index);
        final rooms = widget.bookingData[buildingName]['rooms'] as List<Room>;
        final bookingsByRoom = widget.bookingData[buildingName]['bookings']
            as Map<String, List<Booking>>;

        return BuildingTable(
          buildingName: buildingName,
          rooms: rooms,
          bookingsByRoom: bookingsByRoom,
          selectedDate: widget.selectedDate,
        );
      },
    );
  }
}

class BuildingTable extends StatefulWidget {
  final String buildingName;
  final List<Room> rooms;
  final Map<String, List<Booking>> bookingsByRoom;
  final DateTime selectedDate;

  const BuildingTable({
    super.key,
    required this.buildingName,
    required this.rooms,
    required this.bookingsByRoom,
    required this.selectedDate,
  });

  @override
  State<BuildingTable> createState() => _BuildingTableState();
}

class _BuildingTableState extends State<BuildingTable> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: Border.all(color: Colors.transparent),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      initiallyExpanded: _isExpanded,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(widget.buildingName[0] + widget.buildingName[1]),
      ),
      title: Text(widget.buildingName),
      onExpansionChanged: (value) => setState(() => _isExpanded = value),
      children: [
        Card(
          child: InteractiveViewer(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var room in widget.rooms) ...[
                          //if first, elseif odd else if even
                          if (widget.rooms.indexOf(room) == 0)
                            BookingRow(
                              room: room,
                              bookings: widget.bookingsByRoom[room.name] ?? [],
                              first: true,
                              odd: true,
                              selectedDate: widget.selectedDate,
                            )
                          else if (widget.rooms.indexOf(room) % 2 == 0)
                            BookingRow(
                              room: room,
                              bookings: widget.bookingsByRoom[room.name] ?? [],
                              first: false,
                              odd: true,
                              selectedDate: widget.selectedDate,
                            )
                          else
                            BookingRow(
                              room: room,
                              bookings: widget.bookingsByRoom[room.name] ?? [],
                              first: false,
                              odd: false,
                              selectedDate: widget.selectedDate,
                            ),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
