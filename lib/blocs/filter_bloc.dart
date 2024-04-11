import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/filter.dart';

abstract class FilterEvent extends Equatable {}

class FilterUpdated extends FilterEvent {
  final Filter newFilter;

  FilterUpdated(this.newFilter);

  @override
  List<Object> get props => [newFilter];
}

class FilterBloc extends Bloc<FilterEvent, Filter> {
  FilterBloc() : super(Filter()) {
    on<FilterUpdated>((event, emit) => emit(event.newFilter));
  }
}
