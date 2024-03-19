import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' // new
    hide
        EmailAuthProvider,
        PhoneAuthProvider; // new
import 'package:flutter/material.dart'; // new
import 'package:provider/provider.dart'; // new
import '../app_state.dart'; // new
import 'package:go_router/go_router.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text('Settings Screen'),
      ),
    );
  }

  
}

  //Det gamla Filip hade i settings
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: Text('Settings')),
  //       body: Center(
  //           child: Consumer<ApplicationState>(
  //         builder: (context, appState, _) => appState.loggedIn
  //             ? ElevatedButton(
  //                 onPressed: () async {
  //                   await FirebaseAuth.instance.signOut();
  //                 },
  //                 child: Text('Sign out'),
  //               )
  //             : ElevatedButton(
  //                 onPressed: () {
  //                   context.push('/sign-in');
  //                 },
  //                 child: Text('Sign in'),
  //               ),
  //       )));
  // }
