import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favourite Rooms'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('rooms')
              .where('favourite', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final roomDocs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: roomDocs.length,
              itemBuilder: (context, index) {
                final roomData = roomDocs[index].data() as Map<String, dynamic>;
                return SizedBox(
                  height: 90, // Adjust the height as needed
                  child: Dismissible(
                    key: Key(roomDocs[index].id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      FirebaseFirestore.instance
                          .collection('rooms')
                          .doc(roomDocs[index].id)
                          .update({'favourite': false});
                    },
                    child: RoomButton(
                      roomName: roomData['name'],
                      backgroundColor: Color(0xFFBFD5BC),
                      roomData: roomData, // Pass roomData to RoomButton
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class RoomButton extends StatefulWidget {
  final String roomName;
  final Color backgroundColor;
  final Map<String, dynamic> roomData;

  const RoomButton({
    required this.roomName,
    required this.backgroundColor,
    required this.roomData,
  });

  @override
  _RoomButtonState createState() => _RoomButtonState();
}

class _RoomButtonState extends State<RoomButton> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.roomData['favourite'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return FavouriteRoomDialog(
                  roomData: widget.roomData,
                  onClose: () {
                    Navigator.of(context).pop();
                  },
                );
              },
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(widget.backgroundColor),
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
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.roomName,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: toggleFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    // Update favorite status in Firestore
    FirebaseFirestore.instance
        .collection('rooms')
        .where('name', isEqualTo: widget.roomData['name']) // Assuming 'name' is the field containing the room name
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({'favourite': isFavorite});
          });
        })
        .catchError((error) {
          print("Failed to update favorite status: $error");
        });
  }
}

class FavouriteRoomDialog extends StatefulWidget {
  final Map<String, dynamic> roomData;
  final VoidCallback onClose;

  const FavouriteRoomDialog({
    Key? key,
    required this.roomData,
    required this.onClose,
  }) : super(key: key);

  @override
  _FavouriteRoomDialogState createState() => _FavouriteRoomDialogState();
}

class _FavouriteRoomDialogState extends State<FavouriteRoomDialog> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.roomData['favourite'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Color(0xFFF0F0F0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0), // Adjust top and bottom padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.roomData['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: widget.onClose,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0), // Adjust top and bottom padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Building:', widget.roomData['building']), // Building
                _buildInfoRow('Floor:', widget.roomData['floor']), // Floor
                _buildInfoRow('Size:', widget.roomData['size']), // Size
                _buildInfoRow('Shared:', widget.roomData['shared']), // Shared
                _buildInfoRow('Amenities:', widget.roomData['amenities']), 
                Row(
                  children: [
                    Text(
                      'Favorite room:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: toggleFavorite,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add your logic for "See available slots" here
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xFFBFD5BC),
                        ),
                      ),
                      child: Text('See available slots'),
                    ),
                    OutlinedButton(
                      onPressed: widget.onClose,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Color(0xFFEFECEC),
                        ),
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

  Widget _buildInfoRow(String label, dynamic value) {
    if (value is bool) {
      value = value ? 'Yes' : 'No';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Text(value.toString()),
        ],
      ),
    );
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    // Update favorite status in Firestore
    FirebaseFirestore.instance
        .collection('rooms')
        .where('name', isEqualTo: widget.roomData['name']) // Assuming 'name' is the field containing the room name
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({'favourite': isFavorite});
          });
        })
        .catchError((error) {
          print("Failed to update favorite status: $error");
        });
  }
}

