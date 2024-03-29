import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timeedit/blocs/authentication_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
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
