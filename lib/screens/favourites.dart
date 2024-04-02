import 'package:flutter/material.dart';

class Favourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favourite Rooms'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            RoomButton(roomName: 'Room 1', backgroundColor: Color(0xFFBFD5BC)),
            RoomButton(roomName: 'Room 2', backgroundColor: Color(0xFFBFD5BC)),
            RoomButton(roomName: 'Room 3', backgroundColor: Color(0xFFBFD5BC)),
            RoomButton(roomName: 'Room 4', backgroundColor: Color(0xFFBFD5BC)),
            RoomButton(roomName: 'Room 5', backgroundColor: Color(0xFFBFD5BC)),
          ],
        ),
      ),
    );
  }
}

class RoomButton extends StatelessWidget {
  final String roomName;
  final Color backgroundColor;

  const RoomButton({required this.roomName, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Set button width to match the width of the ListView
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton(
          onPressed: () {
            // Show the modal panel when the button is pressed
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return FavouriteRoomDialog(
                  roomName: roomName,
                  isShared: true, // Set the shared status according to your logic
                  onClose: () {
                    Navigator.of(context).pop(); // Close the modal panel
                  },
                );
              },
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(backgroundColor),
            padding: MaterialStateProperty.all(EdgeInsets.all(16.0)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft, // Align text to the left
                child: Text(
                  roomName,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black, // Set text color
                  ),
                ),
              ),
              Icon(
                Icons.favorite,
                color: Colors.red, // Set heart icon color to red
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavouriteRoomDialog extends StatelessWidget {
  final String roomName;
  final bool isShared;
  final VoidCallback onClose;

  const FavouriteRoomDialog({Key? key, required this.roomName, required this.isShared, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Color(0xFFF0F0F0), // Set background color to F0F0F0
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  roomName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: onClose,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('House:', 'Sample House'),
                _buildInfoRow('Size:', 'Sample Size'),
                _buildInfoRow('Amenities:', 'Sample Amenities'),
                _buildInfoRow('Shared:', isShared ? 'Yes' : 'No'), // Display shared status
                _buildInfoRow('Favorite room:', ''), // Add row for favorite room
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add your logic for "See available slots" here
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFFBFD5BC)), // Set background color
                      ),
                      child: Text('See available slots'),
                    ),
                    OutlinedButton(
                      onPressed: onClose,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFEFECEC)), // Set border color
                      ),
                      child: Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    // If the label is for "Favorite room", display a filled red heart icon
    if (label == 'Favorite room:') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.favorite,
              color: Colors.red, // Set heart icon color to red
            ),
          ],
        ),
      );
    }
    // Otherwise, display the regular info row
    else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Text(value),
          ],
        ),
      );
    }
  }
}
