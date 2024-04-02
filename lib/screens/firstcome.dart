import 'package:flutter/material.dart';
import 'package:timeedit/screens/maps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirstComeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First-come-first-serve rooms'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'These rooms are free to use - no booking needed!',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final roomDocs = snapshot.data!.docs;
                  // Group rooms by building
                  Map<String, List<DocumentSnapshot>> roomsByBuilding = {};
                  roomDocs.forEach((doc) {
                    final roomData = doc.data() as Map<String, dynamic>;
                    final String building = roomData['building'];
                    if (!roomsByBuilding.containsKey(building)) {
                      roomsByBuilding[building] = [];
                    }
                    roomsByBuilding[building]!.add(doc);
                  });
                  return Column(
                    children: roomsByBuilding.entries.map((entry) {
                      final buildingName = entry.key;
                      final buildingRooms = entry.value;
                      return AccordionWidget(
                        title: buildingName,
                        content: buildingRooms.map((doc) {
                          final roomData = doc.data() as Map<String, dynamic>;
                          final bool isBookable = roomData['bookable'];
                          if (!isBookable) {
                            return roomData['name'];
                          } else {
                            return null; // Don't include bookable rooms
                          }
                        }).where((room) => room != null).toList().cast<String>(),
                        backgroundColor: Colors.grey, // You can set your own color here
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class AccordionWidget extends StatefulWidget {
  final String title;
  final List<String> content;
  final Color backgroundColor; // Background color

  AccordionWidget(
      {required this.title,
      required this.content,
      required this.backgroundColor});

  @override
  _AccordionWidgetState createState() => _AccordionWidgetState();
}

class _AccordionWidgetState extends State<AccordionWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor, // Set the background color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: TextStyle(color: Colors.black), // Set text color to black
            ),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            trailing: Icon(
              _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black, // Set icon color to black
            ),
          ),
          if (_expanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.content
                  .asMap()
                  .entries
                  .map(
                    (entry) => GestureDetector(
                      onTap: () {
                        _showRoomInfoDialog(context, entry.value);
                      },
                      child: Container(
                        color: entry.key.isOdd
                            ? Color(0xFFD9D9D9)
                            : Color(0xFFEFECE7),
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: TextStyle(
                                      color: Colors
                                          .black), // Set text color to black
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.map),
                                onPressed: () {
                                  // Navigate to the maps screen when map icon is pressed
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MapsScreen()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          Divider(height: 0, color: Colors.black), // Set divider color to black
        ],
      ),
    );
  }

  void _showRoomInfoDialog(BuildContext context, String roomName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          roomName: roomName,
          onClose: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String roomName;
  final VoidCallback onClose;

  const CustomDialog({Key? key, required this.roomName, required this.onClose})
      : super(key: key);

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
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
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
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the maps screen when Get Directions button is pressed
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MapsScreen()));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color(0xFFBFD5BC)), // Set background color
                      ),
                      child: Text('Get Directions?'),
                    ),
                    OutlinedButton(
                      onPressed: onClose,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: Color(0xFFEFECEC)), // Set border color
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
