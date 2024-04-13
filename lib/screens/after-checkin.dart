import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AfterCheckInScreen extends StatefulWidget {
  final String? id;
  const AfterCheckInScreen({Key? key, required this.id}) : super(key: key);

  @override
  _AfterCheckInScreenState createState() => _AfterCheckInScreenState();
}

class _AfterCheckInScreenState extends State<AfterCheckInScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                context.go('/checkin');
              })
        ],
        title: Text('${widget.id}'),
      ),
      body: 
    );
  }
}
