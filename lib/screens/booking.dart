import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeedit/blocs/booking_bloc.dart';
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

  const BuildingsTable({Key? key, required this.bookingData}) : super(key: key);

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
        );
      },
    );
  }
}

class BuildingTable extends StatefulWidget {
  final String buildingName;
  final List<Room> rooms;
  final Map<String, List<Booking>> bookingsByRoom;

  const BuildingTable({
    Key? key,
    required this.buildingName,
    required this.rooms,
    required this.bookingsByRoom,
  }) : super(key: key);

  @override
  State<BuildingTable> createState() => _BuildingTableState();
}

class _BuildingTableState extends State<BuildingTable> {
  final ScrollController _sharedController = ScrollController(); // Define here

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
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var room in widget.rooms) ...[
                    BookingRow(
                      room: room,
                      bookings: widget.bookingsByRoom[room.name] ?? [],
                      scrollController:
                          _sharedController, // Pass the controller here
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
