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
    log('groupBookingsByRoom: $selectedDate');
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
}
