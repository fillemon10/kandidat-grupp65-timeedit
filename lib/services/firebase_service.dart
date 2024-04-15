import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:go_router/go_router.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/models/room.dart';
import 'package:timeedit/services/firebase_options.dart';

class FirebaseService {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      FirebaseUIAuth.configureProviders([
        EmailAuthProvider(),
      ]);
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  static Future<Map<String, List<Room>>> groupRoomsByBuilding() async {
    try {
      // Fetch rooms from Firestore (with bookable filter)
      final snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('bookable', isEqualTo: true)
          .get();

      final rooms = snapshot.docs
          .map((doc) => Room.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Group rooms by building
      final roomsByBuilding = <String, List<Room>>{};
      for (final room in rooms) {
        if (!roomsByBuilding.containsKey(room.building)) {
          roomsByBuilding[room.building] = [];
        }
        roomsByBuilding[room.building]!.add(room);
      }

      //order rooms by name
      for (final building in roomsByBuilding.keys) {
        roomsByBuilding[building]!.sort((a, b) => a.name.compareTo(b.name));
      }

      return roomsByBuilding;
    } catch (e) {
      log('Error grouping rooms by building: $e');
      rethrow;
    }
  }

  static Future<Map<String, List<Booking>>> groupBookingsByRoom(
      DateTime selectedDate) async {
    try {
      // Calculate the start and end of the selected day
      DateTime startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));
      // Fetch bookings from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('startTime', isGreaterThanOrEqualTo: startOfDay)
          .where('startTime', isLessThan: endOfDay)
          .get();
      final bookings = snapshot.docs
          .map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      // Group bookings by room
      final bookingsByRoom = <String, List<Booking>>{};
      for (final booking in bookings) {
        if (!bookingsByRoom.containsKey(booking.roomName)) {
          bookingsByRoom[booking.roomName] = [];
        }
        bookingsByRoom[booking.roomName]!.add(booking);
      }

      return bookingsByRoom;
    } catch (e) {
      log('Error grouping bookings by room: $e');
      rethrow;
    }
  }

  static Future<void> addBooking(Booking booking) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .add(booking.toMap());
    } catch (e) {
      log('Error adding booking: $e');
      rethrow;
    }
  }

  //find booking that is active right now for the user
  static Future<(Booking?, String)> findActiveBooking(String roomName) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return (null, '');
      }

      final now = DateTime.now();
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('startTime', isLessThan: now)
          .where('roomName', isEqualTo: roomName)
          .get();

      if (snapshot.docs.isEmpty) {
        return (null, 'No active booking found');
      }
      // do a greater then check to see if the booking is still active
      final activeBooking = snapshot.docs.firstWhere(
          (doc) => (doc.data() as Map<String, dynamic>)['endTime']
              .toDate()
              .isAfter(now),
          orElse: () => throw Exception('No active booking found'));

      final id = activeBooking.id;
      final booking =
          Booking.fromMap(activeBooking.data() as Map<String, dynamic>);
      return (booking, id);
    } catch (e) {
      log('Error finding active booking: $e');
      return (null, 'Error finding active booking'); // More general message
    }
  }

  //check in a booking by updating the checkedIn field
  static Future<bool> checkInBooking(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(id)
          .update({'checkedIn': true});
      return true;
    } catch (e) {
      log('Error checking in booking: $e');
      return false;
    }
  }

  static Future<Room?> fetchRoomDetails(String roomName) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('name', isEqualTo: roomName)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Room.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      log('Error fetching room details: $e');
      rethrow;
    }
  }

  static Future<DateTime?> checkRoomAvailability(String roomName) async {
    try {
      final now = DateTime.now();
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('roomName', isEqualTo: roomName)
          .where('startTime', isLessThan: now)
          .where('checkedIn', isEqualTo: false)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      // do a greater then check to see if the booking is still active
      final activeBooking = snapshot.docs.firstWhere(
          (doc) => (doc.data() as Map<String, dynamic>)['endTime']
              .toDate()
              .isAfter(now),
          orElse: () => throw Exception('No active booking found'));



      final booking =
          Booking.fromMap(activeBooking.data() as Map<String, dynamic>);

      return booking.endTime;
    } catch (e) {
      log('Error checking room availability: $e');
      rethrow;
    }
  }
}
