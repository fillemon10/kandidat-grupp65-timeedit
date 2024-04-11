import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package for DateFormat
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                TitleSection(), // This is the correct placement of TitleSection
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom:
                    40), // Adjust the amount of padding to move the buttons higher
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.push('/my-bookings');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xFFBFD5BC)), // Set background color
                      foregroundColor: MaterialStateProperty.all(Color(0xFF4D4A4A)), // Set text color
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16)), // Adjust button height
                    ),
                    child: Text('My bookings'),
                  ),
                  SizedBox(height: 12), // Add spacing
                  ElevatedButton(
                    onPressed: () {
                      context.push('/first-come-first-served');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xFFBFD5BC)), // Set background color
                      foregroundColor: MaterialStateProperty.all(Color(0xFF4D4A4A)), // Set text color
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16)), // Adjust button height
                    ),
                    child: Text('First-come-first-served rooms'),
                  ),
                  SizedBox(height: 12), // Add spacing
                  ElevatedButton(
                    onPressed: () {
                      context.push('/favourite_rooms');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xFFBFD5BC)), // Set background color
                      foregroundColor: MaterialStateProperty.all(Color(0xFF4D4A4A)), // Set text color
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16)), // Adjust button height
                    ),
                    child: Text('My favourite rooms'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Looking for a free room right now?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFBFD5BC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Room',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(left: 46.0),
                      child: Text(
                        'Building',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Text(
                        'Available until',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.black),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('rooms').limit(7).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No rooms available.'));
                }

                final rooms = snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> roomData = document.data() as Map<String, dynamic>;
                  return _buildRoomItem(roomData['name'], roomData['building']);
                }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(rooms.length, (index) {
                    final room = rooms[index];
                    final color = index.isEven ? Color(0xFFD9D9D9) : Color(0xFFEFECEC);
                    return Container(
                      color: color,
                      child: room,
                    );
                  }),
                );
              },
            ),
            SizedBox(height: 8),
            Spacer(),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  // Navigate to a page showing all rooms
                  context.push('/all-rooms');
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFBFD5BC)),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
                ),
                icon: Icon(Icons.arrow_forward),
                label: Text('See more rooms'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomItem(String? room, String? building) {
  room ??= 'Unknown Room';
  building ??= 'Unknown Building';

  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('bookings').where('roomName', isEqualTo: room).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      final bookings = snapshot.data!.docs;

      if (bookings.isEmpty) {
        return _buildRoomInfo(room, building, null);
      }

      final sortedBookings = bookings.map((DocumentSnapshot document) {
        Map<String, dynamic> bookingData = document.data() as Map<String, dynamic>;
        print('Booking data: $bookingData');
        return {
          'startTime': bookingData['startTime'].toDate() as DateTime?,
          'endTime': bookingData['endTime'].toDate() as DateTime?,
        };
      }).toList()
        ..sort((a, b) {
          final aEndTime = a['endTime'];
          final bEndTime = b['endTime'];
          if (aEndTime != null && bEndTime != null) {
            return aEndTime.compareTo(bEndTime);
          }
          // Handle the case when either endTime is null
          return 0;
        });

      print('Sorted bookings: $sortedBookings');

      final currentDateTime = DateTime.now();
      DateTime? nextBookingStartTime;

      for (var i = 0; i < sortedBookings.length; i++) {
        final startTime = sortedBookings[i]['startTime'] as DateTime;
        final endTime = sortedBookings[i]['endTime'] as DateTime;

        if (currentDateTime.isBefore(startTime)) {
          nextBookingStartTime = startTime;
          break;
        }
      }

      if (nextBookingStartTime != null) {
        final timeDifference = nextBookingStartTime.difference(currentDateTime);
        final hours = timeDifference.inHours;
        final minutes = timeDifference.inMinutes.remainder(60);
  
        final timeUntilNextBooking = hours > 0
            ? 'Free for: ${hours}h ${minutes}m'
            : 'Free for: ${minutes}m';

        return _buildRoomInfo(room, building, DateTime.now().add(timeDifference));
      } else {
        return _buildRoomInfo(room, building, null);
      }
    },
  );
}


  Widget _buildRoomInfo(String? room, String? building, DateTime? availableUntil) {
  room ??= 'Unknown Room';
  building ??= 'Unknown Building';

  final availableUntilText = availableUntil != null ? DateFormat('HH:mm').format(availableUntil) : 'All day!';

  print('Room: $room, Building: $building, Available until: $availableUntilText');

  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            room,
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(left: 42.0),
            child: Text(
              building,
              style: TextStyle(fontSize: 14.0),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            availableUntilText,
            style: TextStyle(fontSize: 14.0),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

}

