import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; // Import for date/time formatting
import 'package:timeedit/models/booking.dart'; // Import the Booking class

class BookingEvent extends StatelessWidget {
  final Booking booking;
  final DateTime roomOpensAt;
  final DateTime roomClosesAt;

  const BookingEvent({
    Key? key,
    required this.booking,
    required this.roomOpensAt,
    required this.roomClosesAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventWidth = _calculateEventWidth(context);
    return Container(
      width: eventWidth,
      height: 50,
      color: Colors.blue,
      child: Center(
        child: Text(
          DateFormat.Hm().format(booking.startTime) +
              '-' +
              DateFormat.Hm().format(booking.endTime),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  double _calculateEventWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final totalDuration = booking.endTime.difference(booking.startTime);
    final roomOpenDuration = roomClosesAt.difference(roomOpensAt);
    return screenWidth *
        (totalDuration.inMilliseconds / roomOpenDuration.inMilliseconds);
  }
}
