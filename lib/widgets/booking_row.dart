import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/models/room.dart';
import 'package:timeedit/widgets/booking_event.dart';
import 'package:intl/intl.dart'; // Import for date/time formatting

class BookingRow extends StatefulWidget {
  final Room room;
  final List<Booking> bookings;
  final DateTime roomOpensAt;
  final DateTime roomClosesAt;

  const BookingRow({
    Key? key,
    required this.room,
    required this.bookings,
    required this.roomOpensAt,
    required this.roomClosesAt,
  }) : super(key: key);

  @override
  State<BookingRow> createState() => _BookingRowState();
}

class _BookingRowState extends State<BookingRow> {
  late List<Widget> _eventWidgets;

  @override
  void initState() {
    super.initState();
    _eventWidgets = _buildEventWidgets();
  }

  List<Widget> _buildEventWidgets() {
    List<Widget> widgets = [];
    DateTime lastEndTime = widget.roomOpensAt;
    for (var booking in widget.bookings) {
      if (booking.startTime.isAfter(lastEndTime)) {
        // Add space between bookings
        widgets.add(_buildEmptySpace(lastEndTime, booking.startTime));
      }
      widgets.add(BookingEvent(
        booking: booking,
        roomOpensAt: widget.roomOpensAt,
        roomClosesAt: widget.roomClosesAt,
      ));
      lastEndTime = booking.endTime;
    }
    // Add space till room closing time
    if (lastEndTime.isBefore(widget.roomClosesAt)) {
      widgets.add(_buildEmptySpace(lastEndTime, widget.roomClosesAt));
    }
    return widgets;
  }

  Widget _buildEmptySpace(DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);
    final screenWidth = MediaQuery.of(context).size.width;
    final emptySpaceWidth = screenWidth *
        (duration.inMilliseconds /
            widget.roomClosesAt.difference(widget.roomOpensAt).inMilliseconds);
    return SizedBox(width: emptySpaceWidth);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.room.name),
            ),
            ..._eventWidgets,
          ],
        ),
      ),
    );
  }
}
