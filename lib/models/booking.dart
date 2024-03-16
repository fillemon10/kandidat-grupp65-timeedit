class Booking {
  final String roomId;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;

  Booking({
    required this.roomId,
    required this.userId,
    required this.startTime,
    required this.endTime,
  });
}
