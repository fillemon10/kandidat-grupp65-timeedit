import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FavouriteRoomsScreen extends StatelessWidget {
  
  /**
   * Make this list be filled automatically by the user's fav rooms
   */
  final List<String> exampleRoomsList = [
    'M1212Ax1',
    'EG3215x1',
    'M1212Bx1',
    'M1215x1',
    'M1212Ax2',
    'EG3215x2',
    'M1212Bx2',
    'M1215x2',
    'M1212Ax3',
    'EG3215x3',
    'M1212Bx3',
    'M1215x3',
    'M1212Ax4',
    'EG3215x4',
    'M1212Bx4',
    'M1215x4',
  ];

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favourite Rooms'
        ),
        centerTitle: true,
        
      ),
      body: Scrollbar(
        thickness: 7,
        radius: Radius.circular(10),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          itemCount: exampleRoomsList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(
                  exampleRoomsList[index]),
                  titleTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),
              onTap: () {
                _showRoomDetails(context, exampleRoomsList[index]);
              },
              ),
              
            );
          }
        )
      )
    );
  }

  void _showRoomDetails(BuildContext context, String roomName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          /**
           * The padding needs to be adjusted so that it fits all screens
           */
          insetPadding: const EdgeInsets.symmetric(vertical: 150),
          title: Center(child: Text('Room: $roomName')),
          content: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /**
                 * Add card contents here
                 */
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Text(
                    'House: ...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300
                    )
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Text(
                    'Size: ...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300
                      ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Text('Amenities: ...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300
                      ),    
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Text('Shared: ...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300
                      ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Text('Is favourite: ...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300
                      ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      print('Added/Removed room as favourite');
                    }, 
                    label: const Text(
                      'Add/Remove as Favourite',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: FloatingActionButton.extended(
                onPressed: (){
                  print('Book the room pressed!');
                }, 
                label : const Text(
                  'Book the room',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300
                  ),
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: const Text(
                  'Close',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
