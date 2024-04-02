import 'dart:developer';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeedit/blocs/authentication_bloc.dart';

class MapsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: Center(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state == AuthenticationState.authenticated)
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<AuthenticationBloc>()
                          .add(AuthenticationEvent.signOutRequested);
                    },
                    child: Text('Sign Out'),
                  ),
                if (state == AuthenticationState.unauthenticated)
                  ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).go('/sign-in');
                    },
                    child: Text('Sign In'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
