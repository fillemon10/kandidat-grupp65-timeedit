import 'package:flutter/material.dart';
import 'package:timeedit/screens/mybookings.dart';
import 'package:timeedit/screens/firstcome.dart';
import 'package:timeedit/screens/favourites.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: const [
                TitleSection(
                  title: 'Looking for a room right now?',
                ),
                CardSection(
                  title: 'Book a room',
                  subtitle: 'Find and book a room now',
                ),
              ],
            ),
          ),
                    Padding(
            padding: const EdgeInsets.only(bottom: 40), // Adjust the amount of padding to move the buttons higher
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyBookings()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16), // Adjust button height
                    ),
                    child: Text('My Bookings'),
                  ),
                  SizedBox(height: 12), // Add spacing
                  ElevatedButton(
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FirstCome()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16), // Adjust button height
                    ),
                    child: Text('First-come-first-served rooms'),
                  ),
                  SizedBox(height: 12), // Add spacing
                  ElevatedButton(
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Favourites()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16), // Adjust button height
                    ),
                    child: Text('My favourite rooms'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String title;

  const TitleSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const CardSection({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(title),
              subtitle: Text(subtitle),
            ),
            DataTableExample(),
          ],
        ),
      ),
    );
  }
}

class DataTableExample extends StatelessWidget {
  const DataTableExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Room',
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'House',
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Available until',
            ),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Sarah')),
            DataCell(Text('19')),
            DataCell(Text('Student')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Janine')),
            DataCell(Text('43')),
            DataCell(Text('Professor')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('William')),
            DataCell(Text('27')),
            DataCell(Text('Associate Professor')),
          ],
        ),
      ],
    );
  }
}
