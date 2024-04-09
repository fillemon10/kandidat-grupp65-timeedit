import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// -------- Theming --------
class ThemeEvent {
  final ThemeMode themeMode;
  ThemeEvent({required this.themeMode});
}

class ThemeState {
  final ThemeMode themeMode;
  ThemeState({required this.themeMode});
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeMode: ThemeMode.system)) {
    on<ThemeEvent>((event, emit) {
      emit(ThemeState(themeMode: event.themeMode));
    });
  }
}

// ---- Settings --------
class SettingsEvent {}

class SettingsState {
  final bool colorBlindMode;
  final bool notifications;
  SettingsState({required this.colorBlindMode, required this.notifications});
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc()
      : super(SettingsState(colorBlindMode: false, notifications: false)) {
    on<SettingsEvent>((event, emit) {
      emit(SettingsState(
          colorBlindMode: !state.colorBlindMode,
          notifications: state.notifications));
    });
  }
}
