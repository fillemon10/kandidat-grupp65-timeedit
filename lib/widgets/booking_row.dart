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
  double _timeSlotWidth = 0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // Use LayoutBuilder to get parent width
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        _timeSlotWidth = availableWidth / _calculateTimeSlots();

        return SizedBox(
          child: Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.room.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      // Time Headers
                      _buildTimeHeaderRow(),
                      // Timeslots and Bookings
                      Container(
                        child: _buildTimeSlotsRow(),
                      )
                    ]),
              ),
            ]),
          ),
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
              left: BorderSide(color: Colors.grey[300]!),
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
      height: 20, // Fixed height for clarity
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
    final booking = widget.bookings.firstWhereOrNull((b) =>
        b.startTime
            .isAfter(slotStart.add(Duration(minutes: _timeSlotInterval))) &&
        b.endTime
            .isBefore(slotStart.add(Duration(minutes: _timeSlotInterval))));

    return booking != null
        ? Container(
            width: _timeSlotWidth,
            height: 10,
            color: Theme.of(context).primaryColor,
          )
        : Container(
            width: _timeSlotWidth,
            height: 10,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
                left: BorderSide(color: Colors.grey[300]!),
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          );
  }

  int _calculateTimeSlots() {
    return 11 * 4;
  }

  void _handleTimeSlotTap(int index) {
    DateTime slotStart =
        _dayStart.add(Duration(minutes: index * _timeSlotInterval));

    if (slotStart.isAfter(_dayStart.subtract(const Duration(minutes: 1))) &&
        slotStart.isBefore(_dayEnd)) {
      log('Time slot tapped: $slotStart');
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
