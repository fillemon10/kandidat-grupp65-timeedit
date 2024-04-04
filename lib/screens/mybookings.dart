import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package

class MyBookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFBFD5BC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              padding: EdgeInsets.all(15.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0), // Adjusted padding for "Date" text
                      child: Text(
                        'Date',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(left: 42.0), // Adjusted padding for "Room" text
                      child: Text(
                        'Room',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(right: 78.0), // Adjusted padding for "Time" text
                      child: Text(
                        'Time',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('userId', isEqualTo: '7W2G4jT783Q9CSQblETud8bNMJR2') // Assuming 'userId' is the field containing the user ID
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No bookings found.'));
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot booking = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () => _showBookingDetails(context, booking),
                        child: _buildBookingItem(
                          _formatDate(booking['startTime'].toDate()),
                          booking['roomName'],
                          _formatTime(booking['startTime'].toDate(), booking['endTime'].toDate()),
                          index,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date); // Format date to YYYY-MM-DD
  }

  String _formatTime(DateTime startTime, DateTime endTime) {
    String formattedStartTime = DateFormat('HH:mm').format(startTime); // Format start time to HH:mm
    String formattedEndTime = DateFormat('HH:mm').format(endTime); // Format end time to HH:mm
    return '$formattedStartTime - $formattedEndTime';
  }

  Widget _buildBookingItem(String date, String room, String time, int index) {
  Color backgroundColor = index % 2 == 0 ? Color(0xFFD9D9D9) : Color(0xFFEFECEC);

  return Container(
    color: backgroundColor,
    padding: EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            date,
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        Expanded(
          flex: 4, // Adjust the flex value to allocate more space to the room column
          child: Padding(
            padding: const EdgeInsets.only(left: 42.0), // Adjusted padding for "Room" text
            child: Text(
              room,
              style: TextStyle(fontSize: 14.0),
            ),
          ),
        ),
        Expanded(
          flex: 3, // Adjust the flex value to allocate more space to the time column
          child: Text(
            time,
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ],
    ),
  );
}


  void _showBookingDetails(BuildContext context, DocumentSnapshot booking) {
  String roomName = booking['roomName']; // Get the room name from the booking

  FirebaseFirestore.instance
      .collection('rooms')
      .where('name', isEqualTo: roomName)
      .get()
      .then((QuerySnapshot roomSnapshot) {
    if (roomSnapshot.docs.isNotEmpty) {
      Map<String, dynamic> roomData = roomSnapshot.docs.first.data() as Map<String, dynamic>;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFBFD5BC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Rounded corners for the dialog
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24.0), // Adjusted padding for the booking title
                    child: Text(
                      'Booking ${_formatBookingTitle(booking)}',
                      style: TextStyle(fontSize: 14.0), // Reduced font size for the booking title
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Name: ${roomData['name']}'),
                Text('Building: ${roomData['building']}'),
                Text('Floor: ${roomData['floor']}'),
                Text('Size: ${roomData['size']}'),
                Text('Amenities: ${roomData['amenities']}'),
                Text('Shared: ${roomData['shared']}'),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // Add edit booking functionality
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFEFECEC)),
                ),
                child: Text('Edit Booking'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Show confirmation dialog before deleting booking
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color(0xFFBFD5BC),
                        title: Text('Cancel Booking'),
                        content: Text('Are you sure you want to cancel this booking?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close confirmation dialog
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Delete booking document from Firestore
                              FirebaseFirestore.instance
                                  .collection('bookings')
                                  .doc(booking.id)
                                  .delete()
                                  .then((_) {
                                Navigator.of(context).pop(); // Close confirmation dialog
                                Navigator.of(context).pop(); // Close booking details dialog
                                // No need to explicitly refresh the list as the stream builder will automatically rebuild the list
                              }).catchError((error) {
                                print('Failed to delete booking: $error');
                                // Handle error
                              });
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFEFECEC)),
                ),
                child: Text('Cancel Booking'),
              ),
            ],
          );
        },
      );
    } else {
      // Room data not found
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFBFD5BC),
            title: Text('Booking ${_formatBookingTitle(booking)}'),
            content: Text('Room information not available.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFEFECEC)),
                ),
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }).catchError((error) {
    print("Failed to fetch room data: $error");
    // Handle error
  });
}


  String _formatBookingTitle(DocumentSnapshot booking) {
    DateTime startTime = booking['startTime'].toDate();
    DateTime endTime = booking['endTime'].toDate();
    return _formatDate(startTime) + ' ' + _formatTime(startTime, endTime);
  }
}
