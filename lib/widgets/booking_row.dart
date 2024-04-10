import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/models/room.dart';
import 'package:timeedit/widgets/new_booking.dart';

class BookingRow extends StatefulWidget {
  final Room room;
  final List<Booking> bookings;
  final bool first;
  final bool odd;

  const BookingRow(
      {super.key,
      required this.room,
      required this.bookings,
      required this.first,
      required this.odd});

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
  double _timeSlotWidth = 0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // Use LayoutBuilder to get parent width
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        _timeSlotWidth = availableWidth / _calculateTimeSlots();

        return Container(
          color: (widget.odd)
              ? Colors.transparent
              : Theme.of(context).primaryColor.withOpacity(0.1),
          child: Row(

              // Main Row for room name and timeslots
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Name Container
                Container(
                  alignment: Alignment.bottomLeft,
                  width: 70, // Adjust width as needed
                  margin: const EdgeInsets.only(right: 5),
                  child: Column(
                    // Wrap 'Text' in Column for alignment control
                    mainAxisAlignment: MainAxisAlignment.end, // Align to bottom
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align to left
                    children: [
                      if (widget.first) SizedBox(height: 16, width: 75),
                      Text(widget.room.name, style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                // Timeslots and Bookings (Flexible for dynamic width)
                Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.first) _buildTimeHeaderRow(),
                        // Timeslots and Bookings
                        Container(
                          child: _buildTimeSlotsRow(),
                        )
                      ]),
                ),
              ]),
        );
      },
    );
  }

  // --- Time Header ---
  Widget _buildTimeHeaderRow() {
    return Row(
      children: List.generate(
        _calculateTimeSlots(),
        (index) =>
            // Wrap with Flexible or Expanded
            _buildTimeHeaderColumn(index),
      ),
    );
  }

  Widget _buildTimeHeaderColumn(int index) {
    DateTime slotStart =
        _dayStart.add(Duration(minutes: index * _timeSlotInterval));
    int slotsPerHour = 60 ~/ _timeSlotInterval;

    // Only display the hour every 4 slots
    if (index % slotsPerHour == 0) {
      return Flexible(
        // Or Expanded
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 0),
          child: Text(
            DateFormat('HH').format(slotStart), // Display only the hour
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 11),
          ),
          width: _timeSlotWidth * 4,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Theme.of(context).disabledColor),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  // --- Timeslots and Bookings ---
  Widget _buildTimeSlotsRow() {
    return SizedBox(
      height: 22, // Fixed height for clarity
      child: Row(
        children: List.generate(
          _calculateTimeSlots(),
          (index) => Flexible(child: _buildTimeSlotColumn(index)),
        ),
      ),
    );
  }

  Widget _buildTimeSlotColumn(int index) {
    DateTime slotStart =
        _dayStart.add(Duration(minutes: index * _timeSlotInterval));

    return SizedBox(
      width: _timeSlotWidth,
      child: Column(
        children: [
          Expanded(
            // Let the booking container fill the space
            child: GestureDetector(
              onTap: () => _handleTimeSlotTap(index),
              child: _buildBookingContainer(slotStart),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingContainer(DateTime slotStart) {
    // Check if there is a booking in this timeslot (15 minutes)
    final booking = widget.bookings.firstWhereOrNull((booking) {
      return booking.startTime.isBefore(slotStart) &&
          booking.endTime.isAfter(slotStart);
    });
    if (booking != null) {
      if (booking.userId == FirebaseAuth.instance.currentUser!.uid) {
        return Container(
          width: _timeSlotWidth,
          height: 10,
          color: Theme.of(context).colorScheme.secondary,
        );
      } else {
        return Container(
          width: _timeSlotWidth,
          height: 10,
          color: Theme.of(context).colorScheme.tertiary,
        );
      }
    } else {
      return Container(
          width: _timeSlotWidth,
          height: 10,
          decoration: BoxDecoration(
            // Full hour: Add left border
            border: (slotStart.minute == 0)
                ? Border(
                    left: BorderSide(color: Theme.of(context).disabledColor),
                  )
                :
                // no border
                Border(),
          ));
    }
  }

  int _calculateTimeSlots() {
    return 11 * 4;
  }

  void _handleTimeSlotTap(int index) {
    DateTime slotStart =
        _dayStart.add(Duration(minutes: index * _timeSlotInterval));

    if (slotStart.isAfter(_dayStart.subtract(const Duration(minutes: 1))) &&
        slotStart.isBefore(_dayEnd)) {
      showModalBottomSheet(
          showDragHandle: true,
          useRootNavigator: true,
          context: context,
          builder: (context) =>
              NewBookingBottomSheet(room: widget.room, startTime: slotStart));
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
