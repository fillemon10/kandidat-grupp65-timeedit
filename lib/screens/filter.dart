import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeedit/screens/home.dart';

enum BookingFilter {
  Whiteboard,
  Window,
  Projector,
}

class FilterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          children: [
            Row(
              children: [
                Icon(
                  Icons.apartment,
                  color: Theme.of(context).primaryColor,
                ), // Icon for amenities
                SizedBox(width: 8), // Added spacing between icon and text
                Text(
                  'Building',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            FilterChipExample(),
            Divider(),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).primaryColor,
                ), // Icon for amenities
                SizedBox(width: 8), // Added spacing between icon and text
                Text(
                  'Amenities',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            FilterChipExample(),
            Divider(),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipExample extends StatefulWidget {
  const FilterChipExample({Key? key}) : super(key: key);

  @override
  State<FilterChipExample> createState() => _FilterChipExampleState();
}

class _FilterChipExampleState extends State<FilterChipExample> {
  Set<BookingFilter> filters = <BookingFilter>{};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: BookingFilter.values.map((filter) {
              return FilterChip(
                label: Text(filter.toString().split('.').last),
                selected: filters.contains(filter),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      filters.add(filter);
                    } else {
                      filters.remove(filter);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
