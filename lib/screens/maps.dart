import 'dart:developer';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeedit/app_state.dart';

class MapsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TransformationController _controller = TransformationController();
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onZoomChange);
  }

  void _onZoomChange() {
    setState(() {
      _currentScale = _controller.value.getMaxScaleOnAxis();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vertical Zoom Demo')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Margin Labels
              Container(
                height: 40,
                child: Row(
                  children: [
                    for (int i = 1; i <= 11; i++)
                      Expanded(
                        // Wrap each number in Expanded
                        child: Center(
                          child: Text(
                            '$i',
                            style: TextStyle(
                              fontSize: 12 * _currentScale,
                              // Adjust the font size based on scale
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: InteractiveViewer(
                  panEnabled: false,
                  transformationController: _controller,
                  boundaryMargin: EdgeInsets.all(100),
                  minScale: 0.1,
                  maxScale: 1.6,
                  child: Image.network(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onZoomChange);
    super.dispose();
  }
}
