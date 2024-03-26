import 'package:bloc/bloc.dart';

enum NavigationEvent { home, book, checkin, maps, settings }

enum NavigationState { home, book, checkin, maps, settings }

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState.home) {
    on<NavigationEvent>((event, emit) {
      switch (event) {
        case NavigationEvent.home:
          emit(NavigationState.home);
          break;
        case NavigationEvent.book:
          emit(NavigationState.book);
          break;
        case NavigationEvent.checkin:
          emit(NavigationState.checkin);
          break;
        case NavigationEvent.maps:
          emit(NavigationState.maps);
          break;
        case NavigationEvent.settings:
          emit(NavigationState.settings);
          break;
      }
    });
  }
}
