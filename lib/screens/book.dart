import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeedit/app_state.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/models/room.dart';
import 'package:timeedit/widgets/booking_event.dart';
import 'package:timeedit/widgets/booking_row.dart';
import 'package:timeedit/widgets/booking_tab_bar.dart';

const int AMOUNT_OF_DAYS = 14;

class BookScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: AMOUNT_OF_DAYS + 1,
      child: Text('Book'),
    );
  }
}

// class BuildingCollapsibleTable extends StatefulWidget {
//   final String buildingName;
//   final List<Room> rooms;
//   final Map<String, List<Booking>> bookingsByRoom; // For storing bookings

//   const BuildingCollapsibleTable(
//       {Key? key,
//       required this.buildingName,
//       required this.rooms,
//       required this.bookingsByRoom})
//       : super(key: key);

//   @override
//   _BuildingCollapsibleTableState createState() =>
//       _BuildingCollapsibleTableState();
// }

// class _BuildingCollapsibleTableState extends State<BuildingCollapsibleTable> {
//   bool _isExpanded = true;

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       shape: Border.all(color: Colors.transparent),
//       childrenPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
//       initiallyExpanded: _isExpanded,
//       leading: CircleAvatar(
//         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//         child: Text(widget.buildingName[0] + widget.buildingName[1]),
//       ),
//       title: Text(widget.buildingName),
//       onExpansionChanged: (value) => setState(() => _isExpanded = value),
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   for (var room in widget.rooms) ...[
//                     BookingRow(
//                       room: room,
//                       bookings: widget
//                           .bookingsByRoom[room.name]!, // Pass specific bookings
//                     ),
//                   ]
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class AllCollapsibleTable extends StatefulWidget {
//   const AllCollapsibleTable({Key? key}) : super(key: key);

//   @override
//   _AllCollapsibleTableState createState() => _AllCollapsibleTableState();
// }

// class _AllCollapsibleTableState extends State<AllCollapsibleTable> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, dynamic>>(
//       // Map to store both rooms and bookings
//       future: _fetchData(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           if (!mounted) return Container();
//           final data = snapshot.data!;
//           return ListView.builder(
//             itemCount: data.keys.length,
//             itemBuilder: (context, index) {
//               final buildingName = data.keys.elementAt(index);
//               final rooms = data[buildingName]['rooms'] as List<Room>;
//               final bookingsByRoom =
//                   data[buildingName]['bookings'] as Map<String, List<Booking>>;
//               return BuildingCollapsibleTable(
//                 buildingName: buildingName,
//                 rooms: rooms,
//                 bookingsByRoom: bookingsByRoom,
//               );
//             },
//           );
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }

//   // Fetch both rooms and bookings
//   Future<Map<String, dynamic>> _fetchData() async {
//     try {
//       final roomsByBuilding = await _groupRoomsByBuilding();
//       final bookingsByRoom = await _groupBookingsByRoom();
//       return roomsByBuilding.map((building, rooms) {
//         return MapEntry(building, {'rooms': rooms, 'bookings': bookingsByRoom});
//       });
//     } catch (e) {
//       log('Error fetching data: $e');
//       rethrow;
//     }
//   }

//   Future<Map<String, List<Room>>> _groupRoomsByBuilding() async {
//     List<Room> rooms =
//         await Provider.of<ApplicationState>(context, listen: false).getRooms();
//     Map<String, List<Room>> roomsByBuilding = {};
//     for (var room in rooms) {
//       if (room.bookable == true) {
//         if (roomsByBuilding.containsKey(room.building)) {
//           roomsByBuilding[room.building]!.add(room);
//         } else {
//           roomsByBuilding[room.building] = [room];
//         }
//       }
//     }
//     return roomsByBuilding;
//   }

//   Future<Map<String, List<Booking>>> _groupBookingsByRoom() async {
//     List<Room> rooms =
//         await Provider.of<ApplicationState>(context, listen: false).getRooms();
//     Map<String, List<Booking>> bookingsByRoom = {};
//     for (var room in rooms) {
//       List<Booking> bookings =
//           await Provider.of<ApplicationState>(context, listen: false)
//               .getBookings(room.name);
//       bookingsByRoom[room.name] = bookings;
//     }
//     return bookingsByRoom;
//   }
// }
