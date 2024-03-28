import 'package:flutter/material.dart';

class FirstCome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First-come-first-serve rooms'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'These rooms are free to use - no booking needed!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20), // Add spacing between the title and accordions
            AccordionWidget(
              title: 'Maskin',
              content: 'Content for Accordion 1',
              color: Colors.green, // Set background color to green
            ),
            SizedBox(height: 16), // Add spacing between accordion items
            AccordionWidget(
              title: 'Kemi',
              content: 'Content for Accordion 2',
              color: Colors.green, // Set background color to green
            ),
            SizedBox(height: 16), // Add spacing between accordion items
            AccordionWidget(
              title: 'Fysik',
              content: 'Content for Accordion 3',
              color: Colors.green, // Set background color to green
            ),
            SizedBox(height: 16), // Add spacing between accordion items
            AccordionWidget(
              title: 'SB',
              content: 'Content for Accordion 4',
              color: Colors.green, // Set background color to green
            ),
          ],
        ),
      ),
    );
  }
}

class AccordionWidget extends StatefulWidget {
  final String title;
  final String content;
  final Color color; // Background color

  AccordionWidget({required this.title, required this.content, required this.color});

  @override
  _AccordionWidgetState createState() => _AccordionWidgetState();
}

class _AccordionWidgetState extends State<AccordionWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color, // Set the background color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: TextStyle(color: Colors.white), // Set text color to white for contrast
            ),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            trailing: Icon(
              _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.white, // Set icon color to white for contrast
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.content,
                style: TextStyle(color: Colors.white), // Set text color to white for contrast
              ),
            ),
          Divider(height: 0, color: Colors.white), // Set divider color to white for contrast
        ],
      ),
    );
  }
}
