import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/models/room.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class StartDateSelected extends BookingEvent {
  final DateTime startDate;

  const StartDateSelected(this.startDate);

  @override
  List<Object> get props => [startDate];
}

class StartTimeSelected extends BookingEvent {
  final TimeOfDay startTime;

  const StartTimeSelected(this.startTime);

  @override
  List<Object> get props => [startTime];
}

class EndTimeSelected extends BookingEvent {
  final TimeOfDay endTime;

  const EndTimeSelected(this.endTime);

  @override
  List<Object> get props => [endTime];
}

class RoomSelected extends BookingEvent {
  final Room room;

  const RoomSelected(this.room);

  @override
  List<Object> get props => [room];
}

class BookingSubmitted extends BookingEvent {}

abstract class BookingState extends Equatable {
  final DateTime? startDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Room? room;

  const BookingState({this.startDate, this.startTime, this.endTime, this.room});

  @override
  List<Object?> get props => [startDate, startTime, endTime, room];
}

class BookingInitial extends BookingState {}

class BookingInProgress extends BookingState {
  const BookingInProgress({
    required DateTime startDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required Room room,
  }) : super(
            startDate: startDate,
            startTime: startTime,
            endTime: endTime,
            room: room);
}

class BookingSuccess extends BookingState {}

class NewBookingBloc extends Bloc<BookingEvent, BookingState> {
  NewBookingBloc() : super(BookingInitial()) {
    on<StartDateSelected>((event, emit) => emit(BookingInProgress(
          startDate: event.startDate,
          startTime: state.startTime ?? TimeOfDay.now(),
          endTime: _adjustEndTime(
                  state.startTime, state.endTime, event.startDate, 15) ??
              TimeOfDay.now(),
          room: state.room ??
              Room(
                  bookable: true,
                  building: '',
                  name: '',
                  campus: '',
                  size: 0,
                  floor: 0,
                  roomNumber: ''),
        )));

    on<StartTimeSelected>((event, emit) => emit(BookingInProgress(
          startDate: state.startDate ?? DateTime.now(),
          startTime: _roundTimeOfDayToNearest15(event.startTime),
          endTime: _adjustEndTime(_roundTimeOfDayToNearest15(event.startTime),
                  state.endTime, state.startDate ?? DateTime.now(), 15) ??
              TimeOfDay.now(),
          room: state.room ??
              Room(
                  bookable: true,
                  building: '',
                  name: '',
                  campus: '',
                  size: 0,
                  floor: 0,
                  roomNumber: ''),
        )));

    on<EndTimeSelected>((event, emit) => emit(BookingInProgress(
          startDate: state.startDate ?? DateTime.now(),
          startTime: _adjustStartTime(
                  state.startTime,
                  _roundTimeOfDayToNearest15(event.endTime),
                  state.startDate ?? DateTime.now(),
                  15) ??
              TimeOfDay.now(),
          endTime: _roundTimeOfDayToNearest15(event.endTime),
          room: state.room ??
              Room(
                  bookable: true,
                  building: '',
                  name: '',
                  campus: '',
                  size: 0,
                  floor: 0,
                  roomNumber: ''),
        )));

    on<BookingSubmitted>((event, emit) async {
      // Ensure start time is always before end time before submission
      if (state is BookingInProgress &&
          state.startDate != null &&
          state.startTime != null &&
          state.endTime != null &&
          isTimeOfDayBefore(state.endTime!, state.startTime!)) {
        // Handle error: Show a message, adjust the times, or prevent submission
        print('Error: End time cannot be before start time');
      } else {
        // Handle booking logic (API call, etc.)
        emit(BookingSuccess());
      }
    });

    on<RoomSelected>((event, emit) => emit(BookingInProgress(
          startDate: state.startDate ?? DateTime.now(),
          startTime: state.startTime ?? TimeOfDay.now(),
          endTime: state.endTime ?? TimeOfDay.now(),
          room: event.room,
        )));
  }
  // Helper functions to adjust Start and End times
  TimeOfDay? _adjustStartTime(
      TimeOfDay? startTime, TimeOfDay? endTime, DateTime date, int duration) {
    if (endTime != null) {
      // Ensure end time is always after or equal to start time
      if (isTimeOfDayBefore(endTime, startTime!) || endTime == startTime) {
        endTime = _roundTimeOfDayToNearest15(
            endTime.replacing(minute: endTime.minute - duration));
      }
    }
    return startTime;
  }

  TimeOfDay? _adjustEndTime(
      TimeOfDay? startTime, TimeOfDay? endTime, DateTime date, int duration) {
    if (startTime != null) {
      // Ensure end time is always after or equal to start time
      if (isTimeOfDayBefore(endTime!, startTime) || endTime == startTime) {
        startTime = _roundTimeOfDayToNearest15(
            startTime.replacing(minute: startTime.minute + duration));
      }
    }
    return endTime;
  }

  bool isTimeOfDayBefore(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) {
      return true;
    } else if (time1.hour == time2.hour && time1.minute < time2.minute) {
      return true;
    } else {
      return false;
    }
  }

  TimeOfDay _roundTimeOfDayToNearest15(TimeOfDay time) {
    int minutes =
        ((time.hour * 60) + time.minute) ~/ 15 * 15; // Integer division by 15
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  // add booking to firebase
  Future<void> addBooking(Booking booking) async 
  {
    try {
      // Add booking to Firestore
      // await FirebaseFirestore.instance.collection('bookings').add(booking.toMap());
    } catch (e) {
      log('Error adding booking: $e');
      rethrow;
    }
  }
}
