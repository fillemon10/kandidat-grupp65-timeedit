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

class BuildingCollapsibleTable extends StatefulWidget {
  final String buildingName;
  final List<Room> rooms;

  const BuildingCollapsibleTable(
      {Key? key, required this.buildingName, required this.rooms})
      : super(key: key);

  @override
  _BuildingCollapsibleTableState createState() =>
      _BuildingCollapsibleTableState();
}

class _BuildingCollapsibleTableState extends State<BuildingCollapsibleTable> {
  bool _isExpanded = true; // Initially expanded

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        initiallyExpanded: _isExpanded,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(widget.buildingName[0] + widget.buildingName[1]),
        ),
        title: Text(widget.buildingName),
        onExpansionChanged: (value) => setState(() => _isExpanded = value),
        // Toggle expansion state
        children: [
          Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 80),
                child: Column(children: [
                  SizedBox(child: Text('Room')), // Room header
                  for (var room in widget.rooms)
                    SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Center(
                              child: Text(room.name),
                            )
                          ],
                        )),
                ]),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      SizedBox(
                        // Header row for times
                        height: 40,
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly, // Distribute times
                          children: [
                            for (var hour = 8; hour <= 18; hour++)
                              Text('$hour'),
                          ],
                        ),
                      ),
                      for (var room in widget.rooms)
                        SizedBox(height: 40, child: RoomCalendarRow(room: room))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Room>>>(
      future: _groupRoomsByBuilding(), // New function to organize rooms
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.keys.length,
            itemBuilder: (context, index) {
              final buildingName = snapshot.data!.keys.elementAt(index);
              final rooms = snapshot.data![buildingName]!;
              return BuildingCollapsibleTable(
                buildingName: buildingName,
                rooms: rooms,
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<Map<String, List<Room>>> _groupRoomsByBuilding() async {
    List<Room> rooms = await Provider.of<ApplicationState>(context).getRooms();
    Map<String, List<Room>> roomsByBuilding = {};
    for (var room in rooms) {
      if (room.bookable == true) {
        if (roomsByBuilding.containsKey(room.building)) {
          roomsByBuilding[room.building]!.add(room);
        } else {
          roomsByBuilding[room.building] = [room];
        }
      }
    }
    return roomsByBuilding;
  }
}
