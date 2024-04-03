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
                return Dismissible(
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
        .doc(widget.roomData['id']) // Assuming you have an 'id' field in your room data
        .update({'favourite': isFavorite});
  }
}


class FavouriteRoomDialog extends StatelessWidget {
  final Map<String, dynamic> roomData;
  final VoidCallback onClose;

  const FavouriteRoomDialog({
    Key? key,
    required this.roomData,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isFavorite = roomData['favourite'] ?? false;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Color(0xFFF0F0F0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  roomData['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
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
                _buildInfoRow('Building:', roomData['building']), // Building
                _buildInfoRow('Floor:', roomData['floor']), // Floor
                _buildInfoRow('Size:', roomData['size']), // Size
                _buildInfoRow('Shared:', roomData['shared']), // Shared
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
                      onPressed: () {
                        // Toggle favorite status
                        FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(roomData['id']) // Assuming you have an 'id' field in your room data
                            .update({'favourite': !isFavorite});
                      },
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
                      onPressed: onClose,
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
}
