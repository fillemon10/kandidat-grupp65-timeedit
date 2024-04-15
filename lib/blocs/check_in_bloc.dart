import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/models/room.dart';
import 'package:timeedit/services/firebase_service.dart';

// -- Events --
abstract class CheckInEvent extends Equatable {
  const CheckInEvent();
  @override
  List<Object> get props => [];
}

class CheckInStarted extends CheckInEvent {
  final String roomName;
  const CheckInStarted(this.roomName);

  @override
  List<Object> get props => [roomName];
}

class CheckInSubmitted extends CheckInEvent {
  final Duration duration; // Add a duration property
  const CheckInSubmitted(this.duration);
}

class CheckInCancelled extends CheckInEvent {}

// -- States --
abstract class CheckInState extends Equatable {
  const CheckInState();
  @override
  List<Object> get props => [];
}

class CheckInInitial extends CheckInState {}

class CheckInLoading extends CheckInState {
  final String roomName;
  const CheckInLoading(this.roomName);
}

class CheckInError extends CheckInState {
  final String roomName;
  final String message;
  const CheckInError(this.roomName, this.message);
}

class CheckInCurrentlyBooked extends CheckInState {
  final String roomName;
  final Room? room;
  final Booking booking; // Store the current booking

  const CheckInCurrentlyBooked(this.roomName, this.room, this.booking);
}

class CheckInAvailableForBooking extends CheckInState {
  final String roomName;
  final Room? room;

  const CheckInAvailableForBooking(this.roomName, this.room);
}

class CheckInSuccess extends CheckInState {
  final String roomName;
  final Room? room;
  final Booking booking;

  const CheckInSuccess(this.roomName, this.room, this.booking);
}

class CheckInBooked extends CheckInState {
  final String roomName;
  final Room? room;
  final Booking booking; // This could be the newly created booking

  const CheckInBooked(this.roomName, this.room, this.booking);
}

class CheckInAlreadyCheckedIn extends CheckInState {
  final String roomName;
  final Room? room;
  final Booking booking;

  const CheckInAlreadyCheckedIn(this.roomName, this.room, this.booking);
}

// -- BLoC --
class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  CheckInBloc() : super(CheckInInitial()) {
    on<CheckInStarted>((event, emit) async {
      emit(CheckInLoading(event.roomName));

      try {
        final (booking, _) =
            await FirebaseService.findActiveBooking(event.roomName);

        if (booking != null) {
          if (booking.checkedIn) {
            emit(CheckInAlreadyCheckedIn(
              event.roomName,
              await FirebaseService.fetchRoomDetails(event.roomName),
              booking,
            ));
          } else {
            if (booking.userId == FirebaseAuth.instance.currentUser?.uid) {
              // Attempt check-in
              if (await _checkIn(event.roomName)) {
                emit(
                  CheckInSuccess(
                    event.roomName,
                    await FirebaseService.fetchRoomDetails(event.roomName),
                    booking, // Could update the booking if necessary
                  ),
                );
              } else {
                emit(CheckInError(
                    event.roomName, 'Check-in failed: Please try again.'));
              }
            } else {
              emit(CheckInCurrentlyBooked(
                event.roomName,
                await FirebaseService.fetchRoomDetails(event.roomName),
                booking,
              ));
            }
          }
        } else {
          emit(CheckInAvailableForBooking(
            event.roomName,
            await FirebaseService.fetchRoomDetails(event.roomName),
          ));
        }
      } catch (e) {
        emit(CheckInError(event.roomName, 'Error checking in: $e'));
      }
    });

    on<CheckInCancelled>((event, emit) => emit(CheckInInitial()));
  }

  Future<bool> _checkIn(String roomName) async {
    var (booking, id) = await FirebaseService.findActiveBooking(roomName);

    if (booking == null) {
      return false;
    }

    if (await FirebaseService.checkInBooking(id)) {
      return true;
    } else {
      return false;
    }
  }
}
