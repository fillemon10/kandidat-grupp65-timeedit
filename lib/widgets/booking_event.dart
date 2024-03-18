import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; // Import for date/time formatting
import 'package:timeedit/models/booking.dart'; // Import the Booking class

class BookingEvent extends StatefulWidget {
  final Booking booking; // Add a property to store the booking

  const BookingEvent(this.booking, {Key? key}) : super(key: key);
  @override
  _BookingEventState createState() => _BookingEventState();
}

class _BookingEventState extends State<BookingEvent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      color: Theme.of(context).colorScheme.secondaryContainer,
      margin: const EdgeInsets.symmetric(
          vertical: 2.0, horizontal: 4.0), // Compact margins
      child: InkWell(
        child: SizedBox(
          height: 40, // Reduced height
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(DateFormat('HH:mm')
                    .format(widget.booking.startTime)), // Formatted
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(DateFormat('HH:mm')
                    .format(widget.booking.endTime)), // Formatted
              )
            ],
          ),
        ),
      ),
    );
  }
}
