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
        child: BlocBuilder<AuthenticationBloc, AuthState>(
          builder: (context, authState) {
            if (authState.isAuthenticated) {
              return ElevatedButton(
                onPressed: () => context
                    .read<AuthenticationBloc>()
                    .add(AuthEvent.signOutRequested),
                child: Text('Sign out'),
              );
            } else {
              return ElevatedButton(
                onPressed: () => context.read<AuthenticationBloc>().add(
                      AuthEvent.signInRequested,
                    ),
                child: Text('Sign in'),
              );
            }
          },
        ),
      ),
    );
  }
}
