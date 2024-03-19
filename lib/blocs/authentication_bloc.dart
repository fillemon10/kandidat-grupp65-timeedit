import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:timeedit/services/firebase_service.dart';
import 'package:equatable/equatable.dart';

// -- Events
enum AuthEvent { appStarted, signInRequested, signOutRequested }

// -- States
class AuthState extends Equatable {
  final bool isAuthenticated;
  final bool isLoading;
  final AuthError? error;

  const AuthState({
    required this.isAuthenticated,
    required this.isLoading,
    this.error,
  });

  @override
  List<Object?> get props => [isAuthenticated, isLoading, error];
}

// -- Errors
class AuthError extends Equatable {
  final String code;
  final String message;

  const AuthError(this.code, this.message);

  @override
  List<Object> get props => [code, message];
}

// -- BLoC
class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  AuthenticationBloc()
      : super(const AuthState(isAuthenticated: false, isLoading: false)) {
    on<AuthEvent>((event, emit) async {
      if (event == AuthEvent.appStarted) {
        await FirebaseService.initialize();
        _listenToUserChanges();
      } else if (event == AuthEvent.signInRequested) {
        emit(const AuthState(isAuthenticated: false, isLoading: true));
        try {
          final user = await FirebaseService.signIn();
          emit(const AuthState(isAuthenticated: true, isLoading: false));
        } on FirebaseAuthException catch (e) {
          emit(AuthState(
              isAuthenticated: false,
              isLoading: false,
              error: AuthError(e.code, e.message.toString())));
        } catch (e) {
          emit(AuthState(
              isAuthenticated: false,
              isLoading: false,
              error: AuthError('general-error', e.toString())));
        }
      } else if (event == AuthEvent.signOutRequested) {
        emit(const AuthState(isAuthenticated: false, isLoading: true));
        try {
          await FirebaseAuth.instance.signOut();
          emit(const AuthState(isAuthenticated: false, isLoading: false));
        } catch (e) {
          emit(AuthState(
              isAuthenticated: true,
              isLoading: false,
              error: AuthError('signout-error',
                  e.toString()))); // Maintain auth state as 'true' until resolved
        }
      }
    });
  }

  void _listenToUserChanges() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        emit(const AuthState(isAuthenticated: true, isLoading: false));
      } else {
        emit(const AuthState(isAuthenticated: false, isLoading: false));
      }
    });
  }
}
