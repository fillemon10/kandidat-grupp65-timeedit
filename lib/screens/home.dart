import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: 
      Column(
        children: <Widget>[
          Expanded(
            flex: 8, 
            child: Text('Looking for a place to study?')
          ),
        ],
      )
      //add a text "Looing for a place to study?" 

    );
  }
}
