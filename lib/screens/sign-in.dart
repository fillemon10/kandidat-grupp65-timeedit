import 'dart:developer';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timeedit/blocs/authentication_bloc.dart';

class CustomSignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(
        showPasswordVisibilityToggle: true,
        actions: [
          ForgotPasswordAction(((context, email) {
            final uri = Uri(
              path: 'sign-in/forgot-password',
              queryParameters: <String, String?>{
                'email': email,
              },
            );
            context.push(uri.toString());
          })),
          AuthStateChangeAction(((context, state) {
            final user = switch (state) {
              SignedIn state => state.user,
              UserCreated state => state.credential.user,
              _ => null
            };
            if (user == null) {
              return;
            }
            if (state is UserCreated) {
              user.updateDisplayName(user.email!.split('@')[0]);
            }
            if (!user.emailVerified) {
              user.sendEmailVerification();
              const snackBar = SnackBar(
                  content: Text(
                      'Please check your email to verify your email address'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            if (state is SignedIn) {
              // Sign-in has completed successfully - update AuthenticationBloc
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationEvent.signInRequested);
              log('state: ${context.read<AuthenticationBloc>().state}');
              context.push('/');
            }
          })),
        ],
      ),
    );
  }
}
