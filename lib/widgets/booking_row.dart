import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/models/room.dart';

class BookingRow extends StatefulWidget {
  final Room room;
  final List<Booking> bookings;

  const BookingRow({super.key, required this.room, required this.bookings});

  @override
  State<BookingRow> createState() => _BookingRowState();
}

class _BookingRowState extends State<BookingRow> {
  final DateTime _dayStart = DateTime.now().copyWith(hour: 8, minute: 0);
  final DateTime _dayEnd = DateTime.now().copyWith(hour: 19, minute: 0);
  final int _timeSlotInterval = 15; // In minutes
  final double _timeSlotWidth = 15; // Example width

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: buildRow(),
      ),
    );
  }

  Widget buildRow() {
    return Container(
        width: _calculateTimeSlots() * _timeSlotWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildRoomHeader(),
            buildTimeGrid(),
            buildEventGrid(),
          ],
        ));
  }

  Widget buildRoomHeader() {
    return Container(
      child: Text(widget.room.name),
    );
  }

  Widget buildTimeGrid() {
    return Container(
      height: 20, // Fixed height for the time grid
      child: Row(
        children: List.generate(
          _calculateTimeSlots(),
          (index) => _buildTimeSlot(index),
        ),
      ),
    );
  }

  Widget _buildTimeSlot(int index) {
    DateTime slotStart =
        _dayStart.add(Duration(minutes: index * _timeSlotInterval));
    return Container(
      width: _timeSlotWidth,
      // Key change:
      child: Text(DateFormat('H').format(slotStart)), // Display only hour
    );
  }

  Widget buildEventGrid() {
    return Container(
      height: 30, // Example height
      child: Stack(
        // Use Stack for positioning
        alignment: AlignmentDirectional.topStart,
        children: [
          ..._buildTimeSlotWidgets(), // Expanded to fill width
          ...widget.bookings.map(buildBookingEvent).toList()
        ],
      ),
    );
  }

  List<Widget> _buildTimeSlotWidgets() {
    return List.generate(
      _calculateTimeSlots(),
      (index) => SizedBox(
        width: _timeSlotWidth,
        child: GestureDetector(
          onTap: () => _handleTimeSlotTap(index),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          ),
        ),
      ),
    );
  }

  Widget buildBookingEvent(Booking booking) {
    final slotIndex = _calculateSlotIndex(booking.startTime);
    final slotOffset = slotIndex * _timeSlotWidth;
    final eventWidth = _calculateEventWidth(booking.startTime, booking.endTime);

    return Positioned(
      // Use Positioned within the Stack
      top: 0,
      left: slotOffset,
      width: eventWidth,
      child: Container(
        height: 30,
        color: Colors.blue,
        child: Center(
          child: Text(
            DateFormat.Hm().format(booking.startTime) +
                '-' +
                DateFormat.Hm().format(booking.endTime),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  int _calculateSlotIndex(DateTime startTime) {
    final difference = startTime.difference(_dayStart);
    return difference.inMinutes ~/ _timeSlotInterval;
  }

  int _calculateTimeSlots() {
    return _dayEnd.difference(_dayStart).inMinutes ~/ _timeSlotInterval;
  }

  double _calculateEventWidth(DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);
    final workdayDuration = _dayEnd.difference(_dayStart);
    final widthRatio = duration.inMinutes /
        workdayDuration.inMinutes; // Modified for hourly accuracy
    return widthRatio * _calculateTimeSlots() * _timeSlotWidth;
  }

  void _handleTimeSlotTap(int index) {
    DateTime slotStart =
        _dayStart.add(Duration(minutes: index * _timeSlotInterval));

    if (slotStart.isAfter(_dayStart.subtract(Duration(minutes: 1))) &&
        slotStart.isBefore(_dayEnd)) {
      log('Time slot tapped: ${DateFormat.Hm().format(slotStart)}');
    } else {
      log('Time slot outside allowed range');
    }
  }
}
