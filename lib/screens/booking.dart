import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  final String qrCode;

  BookingScreen({required this.qrCode});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'QR Code: ${widget.qrCode}',
              style: TextStyle(fontSize: 20),
            ),
            // Add your booking control widgets here
          ],
        ),
      ),
    );
  }
}
