import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';


enum AuthenticationEvent {
  authenticationStatusChanged, // New event for auth state change
  signInRequested,
  signOutRequested
}

enum AuthenticationState { authenticated, unauthenticated }

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthenticationBloc() : super(AuthenticationState.unauthenticated) {
    on<AuthenticationEvent>((event, emit) async {
      switch (event) {
        case AuthenticationEvent.signInRequested:
        if (_firebaseAuth.currentUser != null) {
          emit(AuthenticationState.authenticated);
        } else {
          if (_firebaseAuth.currentUser != null) {
            emit(AuthenticationState.authenticated);
          }
        }
        case AuthenticationEvent.signOutRequested:
          await _firebaseAuth.signOut(); // Sign out
          emit(AuthenticationState.unauthenticated);
          break;
        case AuthenticationEvent
              .authenticationStatusChanged: // Handle auth changes
          if (_firebaseAuth.currentUser != null) {
            emit(AuthenticationState.authenticated);
          } else {
            emit(AuthenticationState.unauthenticated);
          }
          break;
      }
    });

    // Start listening to authentication changes
    _firebaseAuth.authStateChanges().listen((User? user) {
      add(AuthenticationEvent.authenticationStatusChanged);
    });
  }
}
