import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeedit/app_state.dart';
import 'package:timeedit/models/room.dart';
import 'package:timeedit/widgets/booking_row.dart';
import 'package:timeedit/widgets/booking_tab_bar.dart';

const int AMOUNT_OF_DAYS = 14; // Global variable for the number of tab days

class BookScreen extends StatelessWidget {
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

class AllCollapsibleTable extends StatefulWidget {
  const AllCollapsibleTable({Key? key}) : super(key: key);

  @override
  _AllCollapsibleTableState createState() => _AllCollapsibleTableState();
}

class _AllCollapsibleTableState extends State<AllCollapsibleTable> {
  List<Room> _rooms = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Room>>(
      future: Provider.of<ApplicationState>(context).getRooms(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _rooms = snapshot.data ?? [];
          return ListView.builder(
            // Use ListView.builder for efficient indexing
            itemCount: _rooms.length,
            itemBuilder: (context, index) {
              // Access index here
              return CollapsibleTable(
                title:
                    'index: ${index + 1} - ${_rooms[index].name}', // Include index
                table: RoomCalendarRow(room: _rooms[index]),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class CollapsibleTable extends StatefulWidget {
  final String title;
  final Widget table;

  const CollapsibleTable({Key? key, required this.title, required this.table})
      : super(key: key);

  @override
  _CollapsibleTableState createState() => _CollapsibleTableState();
}

class _CollapsibleTableState extends State<CollapsibleTable> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: EdgeInsets.all(0),
      initiallyExpanded: true,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      title: Text(widget.title),
      // Contents
      children: [
        SizedBox(
          height: 50, // Adjust the height as per your requirement
          child: widget.table,
        ),
      ],
    );
  }
}
