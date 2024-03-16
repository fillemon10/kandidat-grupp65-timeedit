import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeedit/models/room.dart';

import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });

    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  // Rooms data
  List<Room> _rooms = [];
  bool _roomsLoaded = false;

  Future<List<Room>> getRooms() async {
    if (!_roomsLoaded) {
      _rooms = await _fetchRooms();
      _roomsLoaded = true;
    }
    return _rooms;
  }

  // Internal helper function for fetching rooms from Firestore
  Future<List<Room>> _fetchRooms() async {
    await init();
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('rooms').get();
      final rooms = snapshot.docs
          .map((doc) => Room.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return rooms;
    } catch (error) {
      log('Error fetching rooms: $error');
      rethrow;
    }
  }
}
