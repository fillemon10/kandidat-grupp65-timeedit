import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  Booking({
    required this.roomName,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.checkedIn,
  });

  final String roomName;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final bool checkedIn;

  factory Booking.fromMap(Map<String, dynamic> json) => Booking(
        roomName: json['roomName'],
        userId: json['userId'],
        startTime: (json['startTime'] as Timestamp).toDate(),
        endTime: (json['endTime'] as Timestamp).toDate(),
        checkedIn: json['checkedIn'],
      );

  Map<String, dynamic> toMap() => {
        'roomName': roomName,
        'userId': userId,
        'startTime': startTime,
        'endTime': endTime,
        'checkedIn': checkedIn,
      };

  static Booking fromJson(Booking booking) {
    return Booking(
      roomName: booking.roomName,
      userId: booking.userId,
      startTime: booking.startTime,
      endTime: booking.endTime,
      checkedIn: booking.checkedIn,
    );
  }
}
