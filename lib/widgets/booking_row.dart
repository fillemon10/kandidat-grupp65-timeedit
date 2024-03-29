import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/models/room.dart';

class BookingRow extends StatefulWidget {
  final Room room;
  final List<Booking> bookings;
  final ScrollController scrollController;

  const BookingRow(
      {super.key,
      required this.room,
      required this.bookings,
      required this.scrollController});

  @override
  State<BookingRow> createState() => _BookingRowState();
}

class _BookingRowState extends State<BookingRow> {
  final DateTime _dayStart = DateTime.now().copyWith(hour: 8, minute: 0);
  final DateTime _dayEnd = DateTime.now().copyWith(hour: 19, minute: 0);
  final int _timeSlotInterval = 15;
  final double _timeSlotWidth = 20;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          buildRoomHeader(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: buildRow(),
          )
        ],
      ),
    );
  }

  Widget buildRow() {
    return SizedBox(
      width: _calculateTimeSlots() * _timeSlotWidth, // Adjust if needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTimeGrid(),
        ],
      ),
    );
  }

  Widget buildRoomHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(widget.room.name),
    );
  }

  Widget buildTimeGrid() {
    return SizedBox(
      height: 60,
      child: Row(
        children: List.generate(
          _calculateTimeSlots(),
          (index) => _buildTimeSlotWidget(index),
        ),
      ),
    );
  }

  Widget _buildTimeSlot(int index) {
    DateTime slotStart =
        _dayStart.add(Duration(minutes: index * _timeSlotInterval));
    String formattedHour = DateFormat('HH').format(slotStart);
    return SizedBox(
      width: _timeSlotWidth,
      child: Text(formattedHour),
    );
  }

  Widget _buildTimeSlotWidget(int index) {
    DateTime slotStart =
        _dayStart.add(Duration(minutes: index * _timeSlotInterval));
    int slotsPerHour = 60 ~/ _timeSlotInterval;

    String formattedHour =
        DateFormat('HH:mm').format(slotStart); // For detailed output

    return Expanded(
      child: Column(children: [
        // Show time label only for the first slot of each hour
        if (index % slotsPerHour == 0)
          Text(DateFormat('HH').format(slotStart))
        else
          const SizedBox(
            height: 20,
            width: 20,
          ),
        SizedBox(
            width: _timeSlotWidth,
            height: 40,
            child: GestureDetector(
              onTap: () => _handleTimeSlotTap(index),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
              ),
            ))
      ]),
    );
  }

  int _calculateTimeSlots() {
    return _dayEnd.difference(_dayStart).inMinutes ~/ _timeSlotInterval;
  }

  void _handleTimeSlotTap(int index) {
    DateTime slotStart =
        _dayStart.add(Duration(minutes: index * _timeSlotInterval));

    if (slotStart.isAfter(_dayStart.subtract(const Duration(minutes: 1))) &&
        slotStart.isBefore(_dayEnd)) {
      log('Time slot tapped: ${DateFormat.Hm().format(slotStart)}');
    } else {
      log('Time slot outside allowed range');
    }
  }
}
