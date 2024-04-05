import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingDetailsDialog extends StatefulWidget {
  final DocumentSnapshot booking;
  final Map<String, dynamic> roomData;

  BookingDetailsDialog({required this.booking, required this.roomData});

  @override
  _BookingDetailsDialogState createState() => _BookingDetailsDialogState();
}

class _BookingDetailsDialogState extends State<BookingDetailsDialog> {
  late DateTime newStartTime;
  late DateTime newEndTime;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    newStartTime = widget.booking['startTime'].toDate();
    newEndTime = widget.booking['endTime'].toDate();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFBFD5BC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 6.0), // Adjust padding
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Text(
                'Booking ${_formatBookingTitle(widget.booking)}',
                style: TextStyle(fontSize: 14.0),
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
      content: SingleChildScrollView( // Wrap the content in a SingleChildScrollView
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Set the width to 80% of the screen width
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Room Information:'),
              SizedBox(height: 8),
              Text('Name: ${widget.roomData['name']}'),
              Text('Building: ${widget.roomData['building']}'),
              Text('Floor: ${widget.roomData['floor']}'),
              Text('Size: ${widget.roomData['size']}'),
              Text('Amenities: ${widget.roomData['amenities']}'),
              Text('Shared: ${widget.roomData['shared']}'),
              SizedBox(height: 16),
              isEditing
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Edit booking time:'),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => _selectStartTime(context),
                              style: ButtonStyle( // Reduce button size
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)),
                              ),
                              child: Text(DateFormat('HH:mm').format(newStartTime)),
                            ),
                            ElevatedButton(
                              onPressed: () => _selectEndTime(context),
                              style: ButtonStyle( // Reduce button size
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)),
                              ),
                              child: Text(DateFormat('HH:mm').format(newEndTime)),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(height:0), // Add some space between the buttons and the bottom of the pop-up window
            ],
          ),
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust actions padding
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isEditing) {
                    // Save changes
                    _updateBooking();
                    isEditing = false;
                  } else {
                    // Enable editing
                    isEditing = true;
                  }
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFFEFECEC)),
              ),
              child: Text(isEditing ? 'Save Changes' : 'Edit Booking'),
            ),
            SizedBox(width: 8),
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
                            FirebaseFirestore.instance.collection('bookings').doc(widget.booking.id).delete().then((_) {
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
        ),
      ],
    );
  }

 void _selectStartTime(BuildContext context) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(newStartTime),
    // Set to 24-hour format
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );
  if (picked != null) {
    setState(() {
      newStartTime = DateTime(newStartTime.year, newStartTime.month, newStartTime.day, picked.hour, picked.minute);
    });
  }
}

void _selectEndTime(BuildContext context) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(newEndTime),
    // Set to 24-hour format
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );
  if (picked != null) {
    setState(() {
      newEndTime = DateTime(newEndTime.year, newEndTime.month, newEndTime.day, picked.hour, picked.minute);
    });
  }
}


  void _updateBooking() {
  if (newEndTime.difference(newStartTime).inHours <= 4) {
    FirebaseFirestore.instance.collection('bookings').doc(widget.booking.id).update({
      'startTime': newStartTime,
      'endTime': newEndTime,
    }).then((_) {
      Navigator.of(context).pop(); // Close booking details dialog
    }).catchError((error) {
      print('Failed to update booking: $error');
      // Handle error
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Your booking can be 4 hours maximum.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  String _formatBookingTitle(DocumentSnapshot booking) {
    DateTime startTime = booking['startTime'].toDate();
    DateTime endTime = booking['endTime'].toDate();
    return DateFormat('yyyy-MM-dd HH:mm').format(startTime) + ' - ' + DateFormat('HH:mm').format(endTime);
  }
}
