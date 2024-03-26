import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView(
        children: [
          Text(FirebaseAuth.instance.currentUser != null
              ? 'Email: ${FirebaseAuth.instance.currentUser!.email}'
              : 'No user logged in'),
        ],
      ),
    );
  }
}
