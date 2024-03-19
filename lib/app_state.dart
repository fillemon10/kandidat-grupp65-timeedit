// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart'
//     hide EmailAuthProvider, PhoneAuthProvider;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// import 'package:flutter/material.dart';
// import 'services/firebase_options.dart';

// class ApplicationState extends ChangeNotifier {
//   ApplicationState() {
//     init();
//   }

//   bool _loggedIn = false;
//   bool get loggedIn => _loggedIn;

//   Future<void> init() async {
//     await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform);
//     FirebaseUIAuth.configureProviders([
//       EmailAuthProvider(),
//     ]);

//     FirebaseAuth.instance.userChanges().listen((user) {
//       if (user != null) {
//         _loggedIn = true;
//       } else {
//         _loggedIn = false;
//       }
//       notifyListeners();
//     });
//   }

//   // Rooms data
//   List<Room> _rooms = [];
//   bool _roomsLoaded = false;

//   Future<List<Room>> getRooms() async {
//     if (!_roomsLoaded) {
//       _rooms = await _fetchRooms();
//       _roomsLoaded = true;
//     }
//     return _rooms;
//   }

//   // Internal helper function for fetching rooms from Firestore
//   Future<List<Room>> _fetchRooms() async {
//     await init();
//     try {
//       final snapshot =
//           await FirebaseFirestore.instance.collection('rooms').get();
//       final rooms = snapshot.docs
//           .map((doc) => Room.fromMap(doc.data() as Map<String, dynamic>))
//           .toList();
//       return rooms;
//     } catch (error) {
//       log('Error fetching rooms: $error');
//       rethrow;
//     }
//   }

//   // Bookings data
//   List<Booking> _bookings = [];
//   bool _bookingsLoaded = false;

//   Future<List<Booking>> getBookings(roomName) async {
//     if (!_bookingsLoaded) {
//       _bookings = await _fetchBookings(roomName);
//       _bookingsLoaded = true;
//     }
//     return _bookings;
//   }

//   // Internal helper function for fetching bookings from Firestore
//   Future<List<Booking>> _fetchBookings(roomName) async {
//     await init();
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('bookings')
//           .where('roomName', isEqualTo: roomName)
//           .get();
//       final bookings = snapshot.docs
//           .map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>))
//           .toList();

//       return bookings;
//     } catch (error) {
//       log('Error fetching bookings: $error');
//       rethrow;
//     }
//   }
// }
