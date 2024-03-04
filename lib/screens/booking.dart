import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m3;

class BookingScreen extends StatefulWidget {
  final String qrCode;

  BookingScreen({required this.qrCode});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.blue,
                child: Text(
                  selectedDate == null
                      ? 'Select a date'
                      : 'Selected Date: ${selectedDate!.toString()}',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  itemCount: 24, // Assuming 24 time slots
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    // Generate time slots
                    return GestureDetector(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.blue,
                        child: Text(
                          'Time Slot ${index + 1}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: m3.ColorScheme.fromSwatch(
              primarySwatch: m3.Colors.blue,
              backgroundColor: m3.Colors.white,
              cardColor: m3.Colors.blue,
              onBackground: m3.Colors.white,
              surface: m3.Colors.blue,
              onSurface: m3.Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    // Implement time picker here
    // You can use the showTimePicker function to show the time picker
    // and handle the selected time accordingly
  }
}

void main() {
  runApp(MaterialApp(
    home: BookingScreen(qrCode: 'your_qr_code'),
  ));
}
