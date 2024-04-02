import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Bookings'),
      ),
      body: ListView.builder(
        itemCount: favoriteBookings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteBookings[index]),
          );
        },
      ),
    );
  }
}

List<String> favoriteBookings = [
  'Booking 1',
  'Booking 2',
  'Booking 3',
  // Add more favorite bookings here
];
