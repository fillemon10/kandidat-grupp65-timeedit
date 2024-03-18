import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/models/room.dart';
import 'package:timeedit/widgets/booking_event.dart';

class BookingRow extends StatefulWidget {
  final Room room;
  final List<Booking> bookings;

  const BookingRow({super.key, required this.room, required this.bookings});

  @override
  State<BookingRow> createState() => _BookingRowState();
}

class _BookingRowState extends State<BookingRow> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Column(
        children: [
          ListTile(
            title: Text(widget.room.name),
          ),
          if (widget.bookings.isEmpty)
            const ListTile(title: Text('No bookings')),
          // Filter the bookings before showing them
          for (var booking in widget.bookings
              .where((booking) => booking.roomName == widget.room.name))
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Center the BookingSpan
              children: [
                BookingSpan(booking: booking),
              ],
            ),
        ],
      ),
    );
  }
}

class BookingSpan extends StatelessWidget {
  final Booking booking;

  const BookingSpan({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    // Calculate fractional width based on start and end times
    double widthFraction =
        ((booking.endTime.hour - booking.startTime.hour).clamp(0, 10) / 100);

    return Container(
      height: 30, // Adjust height as needed
      width: MediaQuery.of(context).size.width * widthFraction,
      decoration: BoxDecoration(
        color: Colors.blue, // Example color
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
