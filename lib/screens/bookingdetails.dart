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
      contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 6.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Text(
                'Booking ${_formatBookingTitle(widget.booking)}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
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
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              Text('Name: ${widget.roomData['name']}'),
              Text('Building: ${widget.roomData['building']}'),
              Text('Floor: ${widget.roomData['floor']}'),
              Text('Size: ${widget.roomData['size']}'),
              Text('Amenities: ${widget.roomData['amenities']}'),
              Text('Shared: ${widget.roomData['shared']}'),
              SizedBox(height: 0),
              isEditing
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start time:',
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                ElevatedButton(
                                  onPressed: () => _selectStartTime(context),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)),
                                  ),
                                  child: Text(DateFormat('HH:mm').format(newStartTime)),
                                ),
                              ],
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End time:',
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                ElevatedButton(
                                  onPressed: () => _selectEndTime(context),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)),
                                  ),
                                  child: Text(DateFormat('HH:mm').format(newEndTime)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(height: 0),
            ],
          ),
        ),
      ),
      actionsPadding: EdgeInsets.only(top: 16.0, bottom: 8.0),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isEditing) {
                    _updateBooking();
                    isEditing = false;
                  } else {
                    isEditing = true;
                  }
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFFEFECEC)),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0)),
              ),
              child: Text(isEditing ? 'Save Changes' : 'Edit Booking'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color(0xFFBFD5BC),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cancel Booking'),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.black),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      content: Text('Are you sure you want to cancel this booking?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No', style: TextStyle(color: Colors.black)),
                        ),
                        TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance.collection('bookings').doc(widget.booking.id).delete().then((_) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }).catchError((error) {
                              print('Failed to delete booking: $error');
                            });
                          },
                          child: Text('Yes', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFFEFECEC)),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0)),
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

  void _updateBooking() async {
    QuerySnapshot roomBookingsSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('roomName', isEqualTo: widget.booking['roomName'])
        .get();

    List<DocumentSnapshot> roomBookings = roomBookingsSnapshot.docs;
    roomBookings.removeWhere((doc) => doc.id == widget.booking.id);

    bool hasOverlappingBookings = roomBookings.any((doc) {
      DateTime startTime = doc['startTime'].toDate();
      DateTime endTime = doc['endTime'].toDate();
      return newStartTime.isBefore(endTime) && newEndTime.isAfter(startTime);
    });

    if (hasOverlappingBookings) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The room is already booked for the new time slot.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      if (newEndTime.difference(newStartTime).inHours <= 4) {
        FirebaseFirestore.instance.collection('bookings').doc(widget.booking.id).update({
          'startTime': newStartTime,
          'endTime': newEndTime,
        }).then((_) {
          Navigator.of(context).pop();
        }).catchError((error) {
          print('Failed to update booking: $error');
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
  }

  String _formatBookingTitle(DocumentSnapshot booking) {
    DateTime startTime = booking['startTime'].toDate();
    DateTime endTime = booking['endTime'].toDate();
    return DateFormat('yyyy-MM-dd HH:mm').format(startTime) + ' - ' + DateFormat('HH:mm').format(endTime);
  }
}
