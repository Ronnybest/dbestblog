import 'package:dbestblog/pages/home/bloc/home_events.dart';
import 'package:dbestblog/pages/home/bloc/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvents, HomeStates> {
  HomeBloc() : super(const HomeStates()) {
    on<HomePost>((event, emit) => emit(state.copyWith(postObj: event.posts)));
  }
}
