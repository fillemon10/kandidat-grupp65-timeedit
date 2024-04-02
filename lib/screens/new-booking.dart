import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeedit/models/booking.dart';
import 'package:timeedit/models/room.dart';

class NewBookingScreen extends StatefulWidget {
  final String room;
  final String time;

  NewBookingScreen({required this.room, required this.time});

  @override
  _NewBookingScreenState createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {

  late final TimeOfDay _selectedTime = TimeOfDay.fromDateTime(DateTime.parse(widget.time));
  late TimeOfDay _startTime = _selectedTime;

  late TimeOfDay _endTime = _selectedTime.replacing(hour: _selectedTime.hour + 2);

  void _selectStartTime() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (newTime != null) {
      setState(() {
        _startTime = newTime;
      });
    }
  }

  void _selectEndTime() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (newTime != null) {
      setState(() {
        _endTime = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Booking: ${widget.room} at ${widget.time}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectStartTime,
              child: Text('Select Start Time'),
            ),
            Text(
                'Selected Start Time: ${DateFormat('HH:mm').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, _startTime.hour, _startTime.minute))}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectEndTime,
              child: Text('Select End Time'),
            ),
            Text(
                'Selected End Time: ${DateFormat('HH:mm').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, _endTime.hour, _endTime.minute))}'),
          ],
        ),
      ),
    );
  }
}
