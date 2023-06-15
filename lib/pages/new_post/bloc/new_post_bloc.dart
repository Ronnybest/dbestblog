import 'package:bloc/bloc.dart';
import 'package:dbestblog/pages/new_post/bloc/new_post_events.dart';
import 'package:dbestblog/pages/new_post/bloc/new_post_states.dart';

class NewPostBloc extends Bloc<NewPostEvents, NewPostStates> {
  NewPostBloc() : super(const NewPostStates()) {
    on<ImageNewPost>((event, emit) => null);
    on<DescriptionNewPost>((event, emit) => null);
  }
}
