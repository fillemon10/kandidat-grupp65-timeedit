import 'package:flutter/material.dart';

class AfterCheckInScreen extends StatelessWidget {
  final String id;

  AfterCheckInScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('After Check In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('After Check In Screen'),
            SizedBox(height: 20),
            Text('ID: $id'), // Displaying the ID passed to the screen
          ],
        ),
      ),
    );
  }
}
