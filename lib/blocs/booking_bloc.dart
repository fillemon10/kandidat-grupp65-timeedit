import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/models/room.dart';
import 'package:timeedit/services/firebase_service.dart'; // Your data repository

abstract class BookingEvent extends Equatable {}

class FetchBookingData extends BookingEvent {
  final DateTime selectedDate;
  FetchBookingData(this.selectedDate);
  @override
  List<Object?> get props => [selectedDate];
}

abstract class BookingState extends Equatable {}

class BookingInitial extends BookingState {
  @override
  List<Object?> get props => [];
}

class BookingLoading extends BookingState {
  @override
  List<Object?> get props => [];
}

class BookingLoaded extends BookingState {
  final Map<String, dynamic> bookingData;
  BookingLoaded(this.bookingData);
  @override
  List<Object?> get props => [bookingData];
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
  @override
  List<Object?> get props => [message];
}

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Map<DateTime, Map<String, dynamic>> _cachedData = {};

  BookingBloc() : super(BookingInitial()) {
    on<FetchBookingData>((event, emit) async {
      try {
        if (_cachedData.containsKey(event.selectedDate)) {
          emit(BookingLoaded(_cachedData[event.selectedDate]!));
        } else {
          emit(BookingLoading());

          final data = await _fetchData(event.selectedDate);
          _cachedData[event.selectedDate] = data;

          emit(BookingLoaded(data));
        }
      } catch (e) {
        emit(BookingError('Error loading bookings: $e'));
      }
    });
  }

  Future<Map<String, dynamic>> _fetchData(DateTime selectedDate) async {
    try {
      if (_cachedData.containsKey(selectedDate)) {
        return Map.of(_cachedData[selectedDate]!);
      } else {
        final roomsByBuilding = await FirebaseService.groupRoomsByBuilding();
        final bookingsByRoom =
            await FirebaseService.groupBookingsByRoom(selectedDate);
        final data = roomsByBuilding.map((building, rooms) {
          return MapEntry(
              building, {'rooms': rooms, 'bookings': bookingsByRoom});
        });

        _cachedData[selectedDate] = data;

        return data;
      }
    } catch (e) {
      throw e;
    }
  }
}
