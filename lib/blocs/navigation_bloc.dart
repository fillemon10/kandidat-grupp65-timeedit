import 'package:bloc/bloc.dart';
import 'package:go_router/go_router.dart';

enum NavigationEvent { home, book, maps, settings }

enum NavigationState { home, book, maps, settings }

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
