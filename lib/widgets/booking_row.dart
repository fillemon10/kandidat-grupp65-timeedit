import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  DateTime _dayStart = DateTime.now().copyWith(
      hour: 8, minute: 0, second: 0, millisecond: 0 // Set milliseconds to 0
      );

  DateTime _dayEnd = DateTime.now().copyWith(
      hour: 19, minute: 0, second: 0, millisecond: 0 // Set milliseconds to 0
      );
  final int _timeSlotInterval = 15;
  final double _timeSlotWidth = 10;
  @override
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          buildRoomHeader(),
          _buildTimeLabels(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: widget.scrollController, // Add controller here
            child: buildRow(),
          ),
        ],
      ),
    );
  }

  Widget buildRow() {
    return SizedBox(
      width: _calculateTimeSlots() * _timeSlotWidth,
      child: Stack(
        // Use Stack to layer containers
        alignment: Alignment.topLeft, // Adjust alignment as needed
        children: [
          _buildTimeGrid(), // This will be at the bottom layer
        ],
      ),
    );
  }

  Widget _buildTimeLabels() {
    return Container(
      height: 20, // Set desired height of the time label row
      child: Row(
        children: List.generate(_calculateTimeSlots(), (index) {
          DateTime slotStart =
              _dayStart.add(Duration(minutes: index * _timeSlotInterval));
          int slotsPerHour = 60 ~/ _timeSlotInterval;

          return SizedBox(
              width: _timeSlotWidth*2,
              child: index % slotsPerHour == 0
                  ? Text(DateFormat('HH').format(slotStart),
                      style: const TextStyle(fontSize: 10))
                  :  const SizedBox.shrink()	
              );
        }),
      ),
    );
  }

  Widget buildRoomHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(widget.room.name),
    );
  }

  Widget _buildTimeGrid() {
    return SizedBox(
      height: 60,
      child: Row(
        children: List.generate(
          _calculateTimeSlots(),

          (index) => _buildTimeSlotColumn(index), // Updated function
        ),
      ),
    );
  }

  Widget _buildTimeSlotColumn(int index) {
    DateTime slotStart =
        _dayStart.add(Duration(minutes: index * _timeSlotInterval));
    int slotsPerHour = 60 ~/ _timeSlotInterval;

    return SizedBox(
      // Constrain the width
      width: _timeSlotWidth,
      child: Column(children: [
        Expanded(
          // Ensures Timeslots take remaining space
          child: Column(
            children: [
              for (int i = 0; i < slotsPerHour; i++) ...[
                // Loop for each slot in hour
                if (i > 0)
                  const SizedBox(height: 20)
                else
                  const SizedBox.shrink(), // Spacing
                SizedBox(
                  width: _timeSlotWidth,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => _handleTimeSlotTap(
                        index * slotsPerHour + i), // Adjusted indexing
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                        ),
                        _buildBookingContainer(slotStart
                            .add(Duration(minutes: i * _timeSlotInterval)))
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildTimeSlotWidget(int index) {
    DateTime slotStart =
        _dayStart.add(Duration(minutes: index * _timeSlotInterval));
    int slotsPerHour = 60 ~/ _timeSlotInterval;

    String formattedHour = DateFormat('HH:mm').format(slotStart);

    return SizedBox(
      // Use SizedBox to constrain width
      width: _timeSlotWidth,
      child: Row(
        // Use a Row for horizontal layout
        children: [
          if (index % slotsPerHour == 0)
            Text(
              formattedHour.split(":")[0], // Display only the 'HH' part
              style: const TextStyle(fontSize: 10),
            ),
          Expanded(
            // Expand to fill the remaining space
            child: Column(
              // Column for the timeslot
              children: [
                if (index % slotsPerHour == 0)
                  Text(formattedHour.split(":")[1]) // Display only ':mm' part
                else
                  const SizedBox(
                    height: 20,
                  ),
                SizedBox(
                  width: _timeSlotWidth,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => _handleTimeSlotTap(index),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                        ),
                        _buildBookingContainer(slotStart)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBookingContainer(DateTime slotStart) {
    final booking = widget.bookings.firstWhereOrNull((b) =>
        b.startTime.isAfter(slotStart) &&
        b.endTime
            .isBefore(slotStart.add(Duration(minutes: _timeSlotInterval))));

    return booking != null
        ? Container(
            width: _timeSlotWidth,
            height: 40,
            color: Theme.of(context).primaryColor,
          )
        : const SizedBox.shrink();
  }

  int _calculateTimeSlots() {
    return _dayEnd.difference(_dayStart).inMinutes ~/ _timeSlotInterval;
  }

  void _handleTimeSlotTap(int index) {
    DateTime slotStart =
        _dayStart.add(Duration(minutes: index * _timeSlotInterval));

    if (slotStart.isAfter(_dayStart.subtract(const Duration(minutes: 1))) &&
        slotStart.isBefore(_dayEnd)) {
      context.push(
          "/new-booking/${widget.room.name}/${DateFormat('HH:mm').format(slotStart)}");
    } else {
      log('Time slot outside allowed range');
    }
  }
}

extension ListExtensions<E> on List<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}
